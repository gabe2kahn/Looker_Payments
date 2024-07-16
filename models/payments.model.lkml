connection: "snowflake_credit"

include: "/views/*.view"

datagroup: payments_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "24 hours"
}

persist_with: payments_default_datagroup

label: "Arro Payment Monitoring"

explore: payments {
  join: user_profile {
    type: inner
    sql_on: ${payments.user_id} = ${user_profile.user_id} ;;
    relationship: one_to_many
  }

  join: payment_date_snapshot {
    from:  snapshot_pt
    type: inner
    sql_on: ${payments.user_id} = ${payment_date_snapshot.user_id}
      and ${payments.payment_scheduled_for_date} = ${payment_date_snapshot.snap_date} ;;
    relationship: one_to_many
  }

  join: previous_date_snapshot {
    from: snapshot_pt
    type: inner
    sql_on: ${payments.user_id} = ${previous_date_snapshot.user_id}
      and ${payments.payment_scheduled_for_date} = DATEADD(DAYS,1,${previous_date_snapshot.snap_date}) ;;
    relationship: one_to_many
  }
}

explore: payment_sources {
  join: snapshot_pt {
    type: full_outer
    sql_on: ${payment_sources.user_id} = ${snapshot_pt.user_id} ;;
    relationship: many_to_many
  }
  join: user_profile {
    type: inner
    sql_on: ${payment_sources.user_id} = ${user_profile.user_id} ;;
    relationship: one_to_many
  }
}

explore: connected_account_balance {
  join: snapshot_pt {
    type: full_outer
    sql_on: ${connected_account_balance.user_id} = ${snapshot_pt.user_id}
      and ${connected_account_balance.balance_update_ts_date} between DATEADD(DAYS,-7,${snapshot_pt.snap_date}) AND ${snapshot_pt.snap_date};;
    relationship: many_to_many
  }
}
