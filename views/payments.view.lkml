view: payments {
  sql_table_name: "CUSTOMER"."PAYMENTS"
    ;;
  drill_fields: [processor_payment_id]

  dimension: processor_payment_id {
    primary_key: yes
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
    sql: ${TABLE}."PAYMENT_INITIATED_TS" ;;
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

  dimension: payment_ratio {
    type: number
    sql: ${payment_amount}/NULLIF(${snapshot_pt.outstanding_balance},0) ;;
    value_format_name: percent_1
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

  dimension_group: payment_scheduled_for_ts {
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
    sql: ${TABLE}."PAYMENT_SCHEDULED_FOR_TS" ;;
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

  measure: failed_payments {
    type: count_distinct
    sql: CASE WHEN ${payment_status} = 'failed' THEN ${payment_id} END;;
  }

  measure: average_time_to_payment_failure {
    type: average
    sql: CASE WHEN ${payment_status} = 'failed' THEN DATEDIFF(days,${payment_scheduled_for_ts_date},${last_status_update_ts_date}) END;;
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

  measure: payment_failure_rate {
    type: number
    sql: ${failed_payments} / ${payments};;
    value_format_name: percent_1
  }

  measure: average_payment_ratio {
    type: average
    sql: ${payment_ratio};;
    value_format_name: percent_1
  }

}
