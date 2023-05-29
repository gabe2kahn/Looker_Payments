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
    sql: CAST(${TABLE}."LAST_STATUS_UPDATE_TS" AS TIMESTAMP_NTZ) ;;
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
    sql: CAST(${TABLE}."PAYMENT_POSTED_TS" AS TIMESTAMP_NTZ) ;;
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
    sql: CAST(${TABLE}."PAYMENT_SCHEDULED_AT_TS" AS TIMESTAMP_NTZ) ;;
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
    sql: CAST(${TABLE}."PAYMENT_SCHEDULED_FOR_TS" AS TIMESTAMP_NTZ) ;;
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
  }

  measure: count {
    type: count
    drill_fields: [processor_payment_id, payments.processor_payment_id, payments.count]
  }
}
