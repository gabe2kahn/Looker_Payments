view: payments {
  sql_table_name: "CUSTOMER"."PAYMENTS"
    ;;
  drill_fields: [processor_payment_id]

  dimension: processor_payment_id {
    type: string
    sql: ${TABLE}."PROCESSOR_PAYMENT_ID" ;;
  }

  dimension: autopay_or_manual {
    type: string
    sql: ${TABLE}."AUTOPAY_OR_MANUAL" ;;
  }

  dimension: auto_payment_schedule_id {
    type: string
    sql: ${TABLE}."AUTO_PAYMENT_SCHEDULE_ID" ;;
  }

  dimension: card_id {
    type: string
    sql: ${TABLE}."CARD_ID" ;;
  }

  dimension: business_days_to_payment_failure {
    type: number
    sql: CASE WHEN ${payment_status} = 'failed' THEN (
      DATEDIFF(DAY, COALESCE(${payment_initiated_by_galileo_ts_date},${payment_initiated_ts_date}),${last_status_update_ts_date})
    - DATEDIFF(WEEK, COALESCE(${payment_initiated_by_galileo_ts_date},${payment_initiated_ts_date}), ${last_status_update_ts_date})*2
    - (CASE WHEN DAYNAME(COALESCE(${payment_initiated_by_galileo_ts_date},${payment_initiated_ts_date})) != 'Sun' THEN 1 ELSE 0 END)
    + (CASE WHEN DAYNAME(${last_status_update_ts_date}) != 'Sat' THEN 1 ELSE 0 END)
    ) END ;;
    value_format_name: decimal_0
  }

  dimension: business_days_to_payment_failure_bucket {
    type: string
    sql: CASE WHEN ${business_days_to_payment_failure} > 3 THEN '4+' ELSE CAST(${business_days_to_payment_failure} AS STRING) END ;;
  }

  dimension: days_to_payment_failure {
    type: number
    sql: CASE WHEN ${payment_status} = 'failed' THEN
      DATEDIFF(days,COALESCE(${payment_initiated_by_galileo_ts_date},${payment_initiated_ts_date}),${last_status_update_ts_date}) END;;
    value_format_name: decimal_0
  }

  dimension: payment_initiated_day_of_month {
    type: number
    sql: DAY(${TABLE}."PAYMENT_INITIATED_TS") ;;
  }

  dimension: failure_reason {
    type: string
    sql: ${TABLE}."FAILURE_REASON" ;;
  }

  dimension: failure_reason_detailed {
    type: string
    sql: ${TABLE}."FAILURE_REASON_DETAILED" ;;
  }

  dimension_group: last_status_update_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."LAST_STATUS_UPDATE_TS" ;;
  }

  dimension: last_status_update_date_name {
    type: string
    sql: dayname(${last_status_update_ts_date});;
  }

  dimension_group: last_update_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."LAST_UPDATE_TS" ;;
  }

  dimension: payment_amount {
    type: number
    sql: ${TABLE}."PAYMENT_AMOUNT" ;;
    value_format_name: usd
  }

  dimension: payment_account_current_balance {
    type: number
    sql: ${TABLE}."PAYMENT_ACCOUNT_CURRENT_BALANCE" ;;
    value_format_name: usd
  }

  dimension: payment_account_available_balance {
    type: number
    sql: ${TABLE}."PAYMENT_ACCOUNT_AVAILABLE_BALANCE" ;;
    value_format_name: usd
  }

  dimension: account_available_balance_to_payment_amount_ratio {
    type: number
    sql:  ${payment_account_available_balance} / ${payment_amount} ;;
    value_format_name: percent_1
  }

  dimension: account_available_balance_to_payment_amount_bucket {
    type: string
    sql: CASE
      WHEN ${account_available_balance_to_payment_amount_ratio} < 1 THEN 'a. < 1'
      WHEN ${account_available_balance_to_payment_amount_ratio} <= 2 THEN 'b. 1-2'
      WHEN ${account_available_balance_to_payment_amount_ratio} > 2 THEN 'c. 2+'
    END ;;
  }

  dimension: payment_hold_days {
    type: number
    sql: ${TABLE}."PAYMENT_HOLD_DAYS" ;;
  }

  dimension: payment_id {
    type: number
    primary_key: yes
    sql: ${TABLE}."PAYMENT_ID" ;;
  }

  dimension_group: payment_initiated_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."PAYMENT_INITIATED_TS" AS TIMESTAMP_NTZ) ;;
  }

  dimension_group: payment_initiated_by_galileo_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CAST(${TABLE}."PAYMENT_INITIATED_BY_GALILEO_TS" AS TIMESTAMP_NTZ) ;;
  }


  dimension: payment_initiated_date_name {
    type: string
    sql: dayname(${payment_initiated_ts_date});;
  }

  dimension: payment_method {
    type: string
    sql: CASE ${processor}
      WHEN 'astra' THEN 'Debit'
      WHEN 'peach' THEN 'ACH'
      ELSE ${processor}
    END;;
  }

  dimension_group: payment_posted_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."PAYMENT_POSTED_TS";;
  }

  dimension_group: payment_rescheduled_at_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."PAYMENT_RESCHEDULED_AT_TS" ;;
  }

  dimension_group: payment_rescheduled_for_date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."PAYMENT_RESCHEDULED_FOR_DATE" ;;
  }

  dimension_group: payment_scheduled_at_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."PAYMENT_SCHEDULED_AT_TS" ;;
  }

  dimension_group: payment_scheduled_for_date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."PAYMENT_SCHEDULED_FOR_DATE" ;;
  }

  dimension: payment_source_id {
    type: number
    sql: ${TABLE}."PAYMENT_SOURCE_ID" ;;
  }

  dimension: payment_status {
    type: string
    sql: ${TABLE}."PAYMENT_STATUS" ;;
  }

  dimension: payment_type {
    type: string
    sql: ${TABLE}."PAYMENT_TYPE" ;;
  }

  dimension: plaid_processor_token {
    type: string
    sql: ${TABLE}."PLAID_PROCESSOR_TOKEN" ;;
  }

  dimension: plaid_processor_token_valid {
    type: yesno
    sql: ${plaid_processor_token} IS NOT NULL ;;
  }

  dimension: processor {
    type: string
    sql: ${TABLE}."PROCESSOR" ;;
  }

  dimension_group: statement_end_dt {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."STATEMENT_END_DT" ;;
  }

  dimension: statement_index {
    type: number
    sql: ${TABLE}."STATEMENT_INDEX" ;;
  }

  dimension_group: statement_start_dt {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."STATEMENT_START_DT" ;;
  }

  dimension: statment_balance {
    type: number
    sql: ${TABLE}."STATMENT_BALANCE" ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
    link: {
      label: "Performance Details by User ID"
      url: "https://arro.cloud.looker.com/dashboards/9?User+ID={{ ['payments.user_id'] | url_encode }}"
    }
  }

  measure: payments {
    type: count_distinct
    sql: ${payment_id} ;;
  }

  measure: completed_payments {
    type: count_distinct
    sql: CASE WHEN ${payment_status} IN ('failed','succeeded') THEN ${payment_id} END ;;
  }

  measure: failed_payments {
    type: count_distinct
    sql: CASE WHEN ${payment_status} = 'failed' THEN ${payment_id} END;;
  }

  measure: successful_payments {
    type: count_distinct
    sql: CASE WHEN ${payment_status} = 'succeeded' THEN ${payment_id} END;;
  }

  measure: pending_payments {
    type: count_distinct
    sql: CASE WHEN ${payment_status} = 'pending' THEN ${payment_id} END;;
  }

  measure: rescheduled_payments {
    type: count_distinct
    sql: CASE WHEN ${payment_status} = 'rescheduled' THEN ${payment_id} END;;
  }

  measure: balance_check_canceled_payments {
    type: count_distinct
    sql: CASE WHEN ${payment_status} = 'canceled-for-balance' THEN ${payment_id} END;;
  }

  measure: average_days_to_payment_failure {
    type: average
    sql: ${days_to_payment_failure};;
    value_format_name: decimal_1
  }

  measure: average_business_days_to_payment_failure {
    type: average
    sql: ${business_days_to_payment_failure};;
    value_format_name: decimal_1
  }

  measure: average_successful_payment_amount {
    type: average
    sql: CASE WHEN ${payment_status} = 'succeeded' THEN payment_amount END ;;
    value_format_name: usd
  }

  measure: sum_successful_payment_amount {
    type: sum
    sql: CASE WHEN ${payment_status} = 'succeeded' THEN payment_amount END ;;
    value_format_name: usd_0
  }

  measure: average_failed_payment_amount {
    type: average
    sql: CASE WHEN ${payment_status} = 'failed' THEN payment_amount END ;;
    value_format_name: usd
  }

  measure: average_time_to_first_successful_payment {
    type: average
    sql: CASE WHEN ${payment_status} = 'succeeded' THEN DATEDIFF(days,${user_profile.application_approval_ts_date},${last_status_update_ts_date}) END;;
    value_format_name: decimal_1
  }

  measure: average_time_to_first_failed_payment {
    type: average
    sql: CASE WHEN ${payment_status} = 'failed' THEN DATEDIFF(days,${user_profile.application_approval_ts_date},${last_status_update_ts_date}) END;;
    value_format_name: decimal_1
  }

  measure: users_with_failed_payment {
    type: count_distinct
    sql: CASE WHEN ${payment_status} = 'failed' THEN ${user_id} END ;;
  }

  measure: users_with_successful_payment {
    type: count_distinct
    sql: CASE WHEN ${payment_status} = 'succeeded' THEN ${user_id} END ;;
  }

  measure: payment_failure_rate {
    type: number
    sql: ${failed_payments} / NULLIF(${completed_payments},0);;
    value_format_name: percent_1
  }

  measure: payment_success_rate {
    type: number
    sql: ${successful_payments} / NULLIF(${completed_payments} + ${balance_check_canceled_payments},0);;
    value_format_name: percent_1
  }

  measure: plaid_processor_token_valid_rate {
    type: number
    sql: SUM(CASE WHEN ${plaid_processor_token_valid} = 'Yes' THEN 1 END)/COUNT(DISTINCT ${payment_id}) ;;
    value_format_name: percent_1
  }

  measure: debit_card_payments {
    type: count_distinct
    sql: CASE WHEN ${payment_method} = 'Debit' THEN ${payment_id} END ;;
  }

}
