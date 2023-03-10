local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;

grafana.dashboard.new(
  'MSSQL dashboard Via Grafonnet',
  refresh='1m',
  editable=true,
  time_from='now-12h'
)
.addTemplate(
  grafana.template.datasource(
    'server',
    'prometheus',
    'Prometheus',
    label='Server'
  )
)
.addTemplate(
  template.new(
    'Job',
    '$server',
    'label_values(mssql_instance_local_time, job)',
    label='Job',
    refresh='time',
  )
)
.addTemplate(
  template.new(
    'database',
    '$server',
    'label_values(mssql_database_state,database)',
    label='database',
    refresh='time',
  )
)
.addRow(
  row.new(
     title='Server resource overview',
     height='125px',
  )
  .addPanel(
    singlestat.new(
     'Server Local time',
      span=4,
      valueName='current',
    )
    .addTarget(
      prometheus.target(
        'mssql_instance_local_time{job=~"$Job"}*1000',
        datasource='$server',
      )
    )
  )
  .addPanel(
    singlestat.new(
     'Batch reqs / sec',
     format='bytes',
      span=4,
      valueName='current',
    )
    .addTarget(
      prometheus.target(
        'mssql_batch_requests{job=~"$Job"}',
        format='bytes',
        datasource='$server',
      )
    )
  )
  .addPanel(
    singlestat.new(
     'User errors / sec',
     format='bytes',
      span=4,
      valueName='current',
    )
    .addTarget(
      prometheus.target(
        'mssql_user_errors{job=~"$Job"}-0',
        datasource='$server',
      )
    )
  )
)
.addRow(
  row.new(
    title='Logs Growth',
    height='250px',
  )
  .addPanel(
    graphPanel.new(
      'DB Log growth since last restart',
      span=12,
      fill=1,
      min=0,
      legend_values=true,
      legend_min=true,
      legend_max=true,
      legend_current=true,
      legend_total=false,
      legend_avg=true,
      legend_alignAsTable=true,
      legend_sideWidth=200,
    )
    .addTarget(
      prometheus.target(
        'mssql_log_growths',
        datasource='$server',
      )
    )
    )
)
.addRow(
  row.new(
    title='DB connection',
    height='250px',
  )
  .addPanel(
    graphPanel.new(
      'Acquired connections',
      span=12,
      fill=1,
      min=0,
      legend_values=true,
      legend_min=true,
      legend_max=true,
      legend_current=true,
      legend_total=false,
      legend_avg=true,
      legend_alignAsTable=true,
      legend_sideWidth=200,
    )
    .addTarget(
      prometheus.target(
        'mssql_connections{}',
        datasource='$server',
      )
    )
    )
)