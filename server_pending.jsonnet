local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;
 
 grafana.dashboard.new(
     title='My dashboard',
     editable=true,
     schemaVersion=21,
     # Display metrics over the last 30 minutes
     time_from='now-30m',
     tags=['java']
 ).addPanel(
     grafana.graphPanel.new(
         title='Pending requests',
         # Direct queries to the `Prometheus` data source
         datasource='Prometheus',
         min=0,
         labelY1='pending',
         fill=0,
         decimals=2,
         decimalsY1=0,
         sort='decreasing',
         legend_alignAsTable=true,
         legend_values=true,
         legend_avg=true,
         legend_current=true,
         legend_max=true,
         legend_sort='current',
         legend_sortDesc=true,
     ).addTarget(
         grafana.prometheus.target(
             # Query 'server_pending_requests' from datasource
             expr='server_pending_requests',
             # Label query results as 'alias'
             # (corresponds to specific instances in the application cluster)
             legendFormat='{{alias}}',
         )
     ),
     gridPos = { h: 8, w: 8, x: 0, y: 0 }
 ).addTemplate(
  grafana.template.datasource(
    'PROMETHEUS_DS',
    'prometheus',
    'Prometheus',
    hide='label',
  )
)
 .addTemplate(
     template.new(
    'application',
    '$PROMETHEUS_DS',
    'label_values(application)',
    label='Application',
    refresh='time',
     )
    )
    .addTemplate(
  template.new(
    'instance',
    '$PROMETHEUS_DS',
    'label_values(jvm_memory_used_bytes{application="$application"}, instance)',
    label='Instance',
    refresh='time',
  )
  )