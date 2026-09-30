# Status is computed from the widgetables so it's never stale
# (a heartbeat can go down without anything being saved)
widgetables = dashboard.widgets.map(&:widgetable)

json.(dashboard, :id, :name)
json.status widgetables.any?(&:down?) ? "down" : "up"
json.counts do
  json.total widgetables.size
  json.up widgetables.count(&:up?)
  json.down widgetables.count(&:down?)
  json.pending widgetables.count(&:pending?)
  json.warning widgetables.count { it.up? && it.warning? }
end
json.down_widgets dashboard.widgets.select { it.widgetable.down? }.map(&:name).sort
