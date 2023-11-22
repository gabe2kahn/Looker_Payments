connection: "snowflake_credit"

include: "/views/*.view"

datagroup: payments_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: payments_default_datagroup

label: "Arro Payment Monitoring"

explore: payments {
  join: user_profile {
    type: inner
    sql_on: ${payments.user_id} = ${user_profile.user_id} ;;
    relationship: one_to_many
  }

  always_filter: {
    filters: [payments.payment_initiated_ts_date: "after 1 month ago", user_profile.testing_stage: "Rollout"]
  }
}

explore: payment_sources {
  join: snapshot_pt {
    type: full_outer
    sql_on: ${payment_sources.user_id} = ${snapshot_pt.user_id}
      and ${payment_sources.source_created_ts_date} >= ${snapshot_pt.snap_date}
      and COALESCE(${payment_sources.source_deleted_ts_date},'2999-12-31') < ${snapshot_pt.snap_date};;
    relationship: many_to_many
  }
}

explore: connected_account_balance {
  join: snapshot_pt {
    type: full_outer
    sql_on: ${connected_account_balance.user_id} = ${snapshot_pt.user_id}
      and ${connected_account_balance.balance_update_ts_date} between DATEADD(DAYS,-3,${snapshot_pt.snap_date}) AND ${snapshot_pt.snap_date};;
    relationship: many_to_many
  }
}
