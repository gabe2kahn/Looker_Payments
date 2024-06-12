view: user_profile {
  sql_table_name: "CUSTOMER"."USER_PROFILE"
    ;;

  dimension: activity_status {
    type: string
    sql: ${TABLE}."ACTIVITY_STATUS" ;;
  }

  dimension_group: application_approval_ts {
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
    sql: ${TABLE}."APPLICATION_APPROVAL_TS" ;;
  }

  dimension: approval_test_ind {
    type: string
    sql: ${TABLE}."APPROVAL_TEST_IND" ;;
  }

  dimension: arro_risk_model_1_score {
    type: number
    sql: ${TABLE}."ARRO_RISK_MODEL_1_SCORE" ;;
    value_format_name: decimal_4
  }

  dimension: arro_risk_model_2_score {
    type: number
    sql: ${TABLE}."ARRO_RISK_MODEL_2_SCORE" ;;
    value_format_name: decimal_4
  }

  dimension: arm1_bucket {
    type: string
    sql: CASE
      WHEN ${arro_risk_model_1_score} BETWEEN 0 and 0.05 THEN 'a. 0-5'
      WHEN ${arro_risk_model_1_score} BETWEEN 0.05 and 0.1 THEN 'b. 5-10'
      WHEN ${arro_risk_model_1_score} BETWEEN 0.1 and 0.15 THEN 'c. 10-15'
      WHEN ${arro_risk_model_1_score} BETWEEN 0.15 and 0.2 THEN 'd. 15-20'
      WHEN ${arro_risk_model_1_score} BETWEEN 0.2 and 0.32 THEN 'e. 20-32'
      WHEN ${arro_risk_model_1_score} > 0.32 THEN 'f. 32+'
    END ;;
  }

  dimension: arm2_bucket {
    type: string
    sql: CASE
      WHEN ${arro_risk_model_2_score} BETWEEN 0 and 0.05 THEN 'a. 0-5'
      WHEN ${arro_risk_model_2_score} BETWEEN 0.05 and 0.1 THEN 'b. 5-10'
      WHEN ${arro_risk_model_2_score} BETWEEN 0.1 and 0.15 THEN 'c. 10-15'
      WHEN ${arro_risk_model_2_score} BETWEEN 0.15 and 0.2 THEN 'd. 15-20'
      WHEN ${arro_risk_model_2_score} BETWEEN 0.2 and 0.32 THEN 'e. 20-32'
      WHEN ${arro_risk_model_2_score} > 0.32 THEN 'f. 32+'
    END ;;
  }



  dimension_group: card_creation_ts {
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
    sql: ${TABLE}."CARD_CREATION_TS" ;;
  }

  dimension_group: card_update_ts {
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
    sql: ${TABLE}."CARD_UPDATE_TS" ;;
  }

  dimension: current_base_interest_rate {
    type: string
    sql: ${TABLE}."CURRENT_BASE_INTEREST_RATE" ;;
  }

  dimension: current_card_status {
    type: string
    sql: ${TABLE}."CURRENT_CARD_STATUS" ;;
  }

  dimension: current_credit_limit {
    type: string
    sql: ${TABLE}."CURRENT_CREDIT_LIMIT" ;;
  }

  dimension: highest_socure_fraud_risk_score {
    type: number
    sql: ${TABLE}."HIGHEST_SOCURE_FRAUD_RISK_SCORE" ;;
    value_format_name: decimal_4
  }

  dimension: initial_base_interest_rate {
    type: number
    sql: ${TABLE}."INITIAL_BASE_INTEREST_RATE" ;;
  }

  dimension: initial_credit_limit {
    type: number
    sql: ${TABLE}."INITIAL_CREDIT_LIMIT" ;;
  }

  dimension_group: last_physical_card_ship {
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
    sql: ${TABLE}."LAST_PHYSICAL_CARD_SHIP_DATE" ;;
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

  dimension: line_test_ind {
    type: string
    sql: ${TABLE}."LINE_TEST_IND" ;;
  }

  dimension: loan_id {
    type: string
    sql: ${TABLE}."LOAN_ID" ;;
  }


  dimension: onboarded_ind {
    type: yesno
    sql: ${TABLE}."ONBOARDED_IND" ;;
  }

  dimension: onboarding_status {
    type: string
    sql: ${TABLE}."ONBOARDING_STATUS" ;;
  }

  dimension: physical_card_status {
    type: string
    sql: ${TABLE}."PHYSICAL_CARD_STATUS" ;;
  }

  dimension: rollout_line_assignment {
    type: number
    sql: ${TABLE}."ROLLOUT_LINE_ASSIGNMENT" ;;
  }

  dimension: testing_stage {
    type: string
    sql: ${TABLE}."TESTING_STAGE" ;;
  }

  dimension_group: user_creation_ts {
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
    sql: ${TABLE}."USER_CREATION_TS" ;;
  }

  dimension: user_id {
    type: string
    primary_key: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: open_accounts {
    type: count_distinct
    sql: CASE WHEN coalesce(lower(${activity_status}),'current') != 'closed' THEN ${user_id} END ;;
  }
}
