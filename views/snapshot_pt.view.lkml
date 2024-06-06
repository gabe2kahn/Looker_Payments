view: snapshot_pt {
  sql_table_name: "CUSTOMER"."SNAPSHOT_PT" ;;

  dimension_group: account_closed {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}."ACCOUNT_CLOSED_DATE" ;;
  }
  dimension_group: account_open {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."ACCOUNT_OPEN_DATE" ;;
  }
  dimension: active_level {
    type: string
    sql: ${TABLE}."ACTIVE_LEVEL" ;;
  }
  dimension: autopay_on_ind {
    type: yesno
    sql: ${TABLE}."AUTOPAY_ON_IND" ;;
  }
  dimension: charged_off_reason {
    type: number
    sql: ${TABLE}."CHARGED_OFF_REASON" ;;
  }
  dimension_group: chargeoff {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."CHARGEOFF_DATE" AS TIMESTAMP_NTZ) ;;
  }
  dimension: credit_utilization {
    type: number
    sql: ${TABLE}."CREDIT_UTILIZATION" ;;
  }
  dimension: current_credit_limit {
    type: number
    sql: ${TABLE}."CURRENT_CREDIT_LIMIT" ;;
  }
  dimension: current_interest_rate {
    type: number
    sql: ${TABLE}."CURRENT_INTEREST_RATE" ;;
  }
  dimension: days_overdue {
    type: number
    sql: ${TABLE}."DAYS_OVERDUE" ;;
  }
  dimension: delinq_120_plus_balance {
    type: number
    sql: ${TABLE}."DELINQ_120PLUS_BALANCE" ;;
  }
  dimension: delinq_150_plus_balance {
    type: number
    sql: ${TABLE}."DELINQ_150PLUS_BALANCE" ;;
  }
  dimension: delinq_180_plus_balance {
    type: number
    sql: ${TABLE}."DELINQ_180PLUS_BALANCE" ;;
  }
  dimension: delinq_30_plus_balance {
    type: number
    sql: ${TABLE}."DELINQ_30PLUS_BALANCE" ;;
  }
  dimension: delinq_60_plus_balance {
    type: number
    sql: ${TABLE}."DELINQ_60PLUS_BALANCE" ;;
  }
  dimension: delinq_90_plus_balance {
    type: number
    sql: ${TABLE}."DELINQ_90PLUS_BALANCE" ;;
  }
  dimension: ever_overdue_ind {
    type: string
    sql: ${TABLE}."EVER_OVERDUE_IND" ;;
  }
  dimension: gaco {
    type: number
    sql: ${TABLE}."GACO" ;;
  }
  dimension: galileo_payment_reference_number {
    type: string
    sql: ${TABLE}."GALILEO_PAYMENT_REFERENCE_NUMBER" ;;
  }
  dimension: guco {
    type: number
    sql: ${TABLE}."GUCO" ;;
  }
  dimension: index_rate {
    type: number
    sql: ${TABLE}."INDEX_RATE" ;;
  }
  dimension: interest_accrued {
    type: number
    sql: ${TABLE}."INTEREST_ACCRUED" ;;
  }
  dimension_group: last_update_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}."LAST_UPDATE_TS" ;;
  }
  dimension: loan_type_id {
    type: number
    sql: ${TABLE}."LOAN_TYPE_ID" ;;
  }
  dimension: minimum_payment_due {
    type: number
    sql: ${TABLE}."MINIMUM_PAYMENT_DUE" ;;
  }
  dimension: minimum_payment_fees_amount {
    type: number
    sql: ${TABLE}."MINIMUM_PAYMENT_FEES_AMOUNT" ;;
  }
  dimension: minimum_payment_interest_amount {
    type: number
    sql: ${TABLE}."MINIMUM_PAYMENT_INTEREST_AMOUNT" ;;
  }
  dimension: minimum_payment_late_fees_amount {
    type: number
    sql: ${TABLE}."MINIMUM_PAYMENT_LATE_FEES_AMOUNT" ;;
  }
  dimension_group: most_recent_autopay_authorization {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."MOST_RECENT_AUTOPAY_AUTHORIZATION_DATE" ;;
  }
  dimension_group: most_recent_due {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."MOST_RECENT_DUE_DATE" ;;
  }
  dimension_group: next_due {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."NEXT_DUE_DATE" ;;
  }
  dimension: outstanding_balance {
    type: number
    sql: ${TABLE}."OUTSTANDING_BALANCE" ;;
  }
  dimension: outstanding_fees {
    type: number
    sql: ${TABLE}."OUTSTANDING_FEES" ;;
  }
  dimension: outstanding_interest {
    type: number
    sql: ${TABLE}."OUTSTANDING_INTEREST" ;;
  }
  dimension: outstanding_late_fees {
    type: number
    sql: ${TABLE}."OUTSTANDING_LATE_FEES" ;;
  }
  dimension: overdue_ind {
    type: yesno
    sql: ${TABLE}."OVERDUE_IND" ;;
  }
  dimension: peach_data_id {
    type: number
    sql: ${TABLE}."PEACH_DATA_ID" ;;
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    sql: ${user_id}||${snap_date} ;;
  }

  dimension: purchase_volume {
    type: number
    sql: ${TABLE}."PURCHASE_VOLUME" ;;
  }
  dimension_group: snap {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    convert_tz: no
    datatype: date
    sql: ${TABLE}."SNAP_DATE" ;;
  }
  dimension: snap_recency {
    type: number
    sql: ${TABLE}."SNAP_RECENCY" ;;
  }
  dimension: total_delinq_balance {
    type: number
    sql: ${TABLE}."TOTAL_DELINQ_BALANCE" ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: open_accounts {
    type: count_distinct
    sql: CASE WHEN ${account_closed_date} IS NULL THEN ${user_id} END ;;
  }
}
