CREATE OR REPLACE VIEW experiment_results AS
SELECT experiments.id AS experiment_id,
  experiments.name AS experiment_name,
  conditions.name AS condition_name,
  participant_actions.session_identifier AS session_identifier,
  participant_actions.action_type AS action_type,
  participant_actions.product_id AS product_id,
  products.name AS product_name,
  participant_actions.quantity AS quantity,
  participant_actions.created_at AS created_at
FROM experiments
  JOIN conditions
    ON conditions.experiment_id = experiments.id
  JOIN participant_actions
    ON participant_actions.condition_id = conditions.id
  LEFT JOIN products
    ON participant_actions.product_id = products.id
