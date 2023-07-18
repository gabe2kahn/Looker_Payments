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

  join: snapshot_pt {
    type: inner
    sql_on: ${payments.user_id} = ${snapshot_pt.user_id}
      and ${payments.payment_initiated_ts_date} = DATEADD(DAYS,-1,${snapshot_pt.snap_date_date});;
    relationship: one_to_one
  }


  always_filter: {
    filters: [payments.payment_scheduled_at_ts_date: "after 1 month ago", user_profile.testing_stage: "Rollout"]
  }
}
