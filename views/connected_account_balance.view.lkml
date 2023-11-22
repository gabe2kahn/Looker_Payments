view: connected_account_balance {
  sql_table_name: "CUSTOMER"."CONNECTED_ACCOUNT_BALANCE" ;;

  dimension: access_token_active_ind {
    type: yesno
    sql: ${TABLE}."ACCESS_TOKEN_ACTIVE_IND" ;;
  }
  dimension: account_balance {
    type: number
    sql: ${TABLE}."ACCOUNT_BALANCE" ;;
  }
  dimension: balance_order {
    type: number
    sql: ${TABLE}."BALANCE_ORDER" ;;
  }
  dimension: balance_recency {
    type: number
    sql: ${TABLE}."BALANCE_RECENCY" ;;
  }
  dimension_group: balance_update_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}."BALANCE_UPDATE_TS" ;;
  }
  dimension_group: insert_ts {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}."INSERT_TS" ;;
  }
  dimension: instutition_id {
    type: string
    sql: ${TABLE}."INSTUTITION_ID" ;;
  }
  dimension: payment_source_id {
    type: number
    sql: ${TABLE}."PAYMENT_SOURCE_ID" ;;
  }
  dimension: plaid_access_token_id {
    type: number
    sql: ${TABLE}."PLAID_ACCESS_TOKEN_ID" ;;
  }

  dimension: sync_id {
    type: string
    primary_key: yes
    sql: ${TABLE}."SYNC_ID" ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: users {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: syncs {
    type: count_distinct
    sql: ${sync_id} ;;
  }

  measure: users_with_sync_in_last_day {
    type: count_distinct
    sql: CASE WHEN ${balance_update_ts_date} >= DATEADD(DAYS,-1,${snapshot_pt.snap_date}) THEN ${user_id} END ;;
  }

  measure: users_with_sync_in_last_day_rate {
    type: number
    sql: ${users_with_sync_in_last_day}/ NULLIF(${snapshot_pt.open_accounts},0) ;;
  }
}
