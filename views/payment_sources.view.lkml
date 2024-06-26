view: payment_sources {
  sql_table_name: "CUSTOMER"."PAYMENT_SOURCES" ;;
  drill_fields: [payment_source_id]

  dimension: payment_source_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."PAYMENT_SOURCE_ID" ;;
  }
  dimension: access_token_active_ind {
    type: string
    sql: ${TABLE}."ACCESS_TOKEN_ACTIVE_IND" ;;
  }
  dimension: account_balance {
    type: number
    sql: ${TABLE}."ACCOUNT_BALANCE" ;;
  }
  dimension: account_type {
    type: string
    sql: ${TABLE}."ACCOUNT_TYPE" ;;
  }
  dimension: bank_name {
    type: string
    sql: ${TABLE}."BANK_NAME" ;;
  }
  dimension: connection_provider {
    type: string
    sql: ${TABLE}."CONNECTION_PROVIDER" ;;
  }
  dimension_group: last_status_update_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CAST(${TABLE}."LAST_STATUS_UPDATE_TS" AS TIMESTAMP_NTZ) ;;
  }
  dimension_group: last_update_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}."LAST_UPDATE_TS" ;;
  }
  dimension: processor {
    type: string
    sql: ${TABLE}."PROCESSOR" ;;
  }
  dimension: processor_source_id {
    type: string
    sql: ${TABLE}."PROCESSOR_SOURCE_ID" ;;
  }
  dimension: provider_instrument_id {
    type: string
    sql: ${TABLE}."PROVIDER_INSTRUMENT_ID" ;;
  }
  dimension_group: source_created_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}."SOURCE_CREATED_TS" ;;
  }
  dimension_group: source_deleted_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}."SOURCE_DELETED_TS" ;;
  }
  dimension: source_last_four {
    type: string
    sql: ${TABLE}."SOURCE_LAST_FOUR" ;;
  }
  dimension: user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: payment_sources {
    type: count_distinct
    sql: ${payment_source_id} ;;
  }

  measure: active_payment_sources {
    type: count_distinct
    sql: CASE WHEN ${source_deleted_ts_date} IS NULL and ${account_type} NOT IN ('debit-card-v2','debit-card') THEN ${payment_source_id} END ;;
  }

  measure: users_with_active_payment_source {
    type: count_distinct
    sql: CASE WHEN ${source_created_ts_date} <= ${snapshot_pt.snap_date}
      and COALESCE(${source_deleted_ts_date},'3000-01-01') > ${snapshot_pt.snap_date}
      and ${snapshot_pt.account_closed_date} IS NULL and ${snapshot_pt.chargeoff_date} IS NULL
      and ${account_type} NOT IN ('debit-card-v2','debit-card')
    THEN ${user_id}  END ;;
  }

  measure: active_access_token_payment_sources {
    type: count_distinct
    sql: CASE
      WHEN ${access_token_active_ind} = 'TRUE'
        and ${source_created_ts_date} <= ${snapshot_pt.snap_date}
        and COALESCE(${source_deleted_ts_date},'3000-01-01') > ${snapshot_pt.snap_date}
        and ${account_type} NOT IN ('debit-card-v2','debit-card')
      THEN ${payment_source_id} END ;;
  }

  measure: active_access_token_users {
    type: count_distinct
    sql: CASE WHEN ${access_token_active_ind} = 'TRUE'
      and ${snapshot_pt.account_closed_date} IS NULL and ${snapshot_pt.chargeoff_date} IS NULL
      and ${source_created_ts_date} <= ${snapshot_pt.snap_date}
      and COALESCE(${source_deleted_ts_date},'3000-01-01') > ${snapshot_pt.snap_date}
      and ${account_type} NOT IN ('debit-card-v2','debit-card')
    THEN ${user_id} END ;;
  }

  measure: payment_source_active_access_token_rate {
    type: number
    sql: ${active_access_token_payment_sources} / NULLIF(${active_payment_sources},0);;
    value_format_name: percent_1
  }

  measure: user_active_access_token_rate {
    type: number
    sql: ${active_access_token_users} / NULLIF(${snapshot_pt.open_accounts},0);;
    value_format_name: percent_1
  }

  measure: user_no_payment_source_rate {
    type: number
    sql: 1- ${users_with_active_payment_source} / NULLIF(${snapshot_pt.open_accounts},0);;
    value_format_name: percent_1
  }
}
