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
