json.partial! "api/v1/dashboards/widget", widget: @widget

json.readings @widget.readings.where(created_at: Reading.retention_for(@widget).ago..).order(:created_at), :created_at, :value, :code
json.status_changes @widget.status_changes.where(created_at: StatusChange::RETENTION.ago..).order(:created_at), :created_at, :status
