local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local template = grafana.template;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;

grafana.dashboard.new(
  'Elastic dashboard Via Graffonet',
  refresh='1m',
  editable=true,
  time_from='now-12h',
  uid='KquscW-Vz'
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
    'cluster',
    '$server',
    'label_values(elasticsearch_cluster_health_status, cluster)',
    label='cluster',
    refresh='time',
  )
)
.addRow(
  row.new(
     title='Clusters',
     height='125px',
  )
  .addPanel(
    singlestat.new(
     'Running Nodes',
      span=4,
      valueName='current',
    )
    .addTarget(
      prometheus.target(
        'sum(elasticsearch_cluster_health_number_of_nodes{cluster=~"$cluster"})/count(elasticsearch_cluster_health_number_of_nodes{cluster=~"$cluster"})',
        datasource='$server',
      )
    )
  )
   .addPanel(
    singlestat.new(
      'Active Data Nodes',
      span=4,
      valueName='current',
    )
    .addTarget(
      prometheus.target(
        'elasticsearch_cluster_health_number_of_data_nodes{cluster=~"$cluster"}',
        datasource='$server',
      )
    )
  )
   .addPanel(
    singlestat.new(
      'Pending task',
      span=4,
      valueName='current'
    )
    .addTarget(
      prometheus.target(
        'elasticsearch_cluster_health_number_of_pending_tasks',
        datasource='$server',
      )
    )
  )
)
.addRow(
  row.new(
     title='Shards',
    height='125px',
  )
  .addPanel(
    singlestat.new(
      'Active Shards',
      span=4,
      valueName='current',
    )
    .addTarget(
      prometheus.target(
        'elasticsearch_cluster_health_active_shards{cluster=~"$cluster"}',
        datasource='$server',
      )
    )
  )
   .addPanel(
    singlestat.new(
      'Active Primary Shards',
      span=4,
      valueName='current',
    )
    .addTarget(
      prometheus.target(
        'elasticsearch_cluster_health_active_primary_shards{cluster=~"$cluster"}',
        datasource='$server',
      )
    )
  )
   .addPanel(
    singlestat.new(
      'Unassigned Shards',
       span=4,
      valueName='current',
    )
    .addTarget(
      prometheus.target(
        'elasticsearch_cluster_health_unassigned_shards{cluster=~"$cluster"}',
        datasource='$server',
      )
    )
  )
)
.addRow(
  row.new(
    title='Documents',
    height='250px',
  )
  .addPanel(
    graphPanel.new(
      'Documents indexed',
      span=6,
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
        'sum(elasticsearch_indices_docs{cluster=~"$cluster"})',
        legendFormat='Documents',
        datasource='$server',
      )
    )
    )
    .addPanel(
    graphPanel.new(
      'Index Size',
      span=6,
      fill=1,
      min=0,
      format='bytes',
      decimals=2,
      legend_values=true,
      legend_min=true,
      legend_max=true,
      legend_current=true,
      legend_total=false,
      legend_avg=true,
      legend_alignAsTable=true,
    )
    .addTarget(
      prometheus.target(
        'sum(elasticsearch_indices_store_size_bytes{cluster=~"$cluster"})',
        legendFormat='Index Size',
        datasource='$server',
      )
    ),
    gridPos = { h: 9, w: 12, x: 0, y: 18}
    )
    .addPanel(
    graphPanel.new(
      'Documents Indexed Rate',
      span=6,
      fill=1,
      min=0,
      format='Mib',
      decimals=2,
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
        'rate(elasticsearch_indices_indexing_index_total{cluster=~"$cluster"}[1h])',
        legendFormat='Documents Indexed Rate',
        datasource='$server',
      )
    )
    )
    .addPanel(
    graphPanel.new(
      'Query Rate',
      span=6,
      fill=1,
      min=0,
      decimals=3,
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
        'rate(elasticsearch_indices_search_fetch_total{cluster=~"$cluster"}[1h])',
        legendFormat='Query Rate',
        datasource='$server',
      )
    )
    )
  )
  
.addRequired('grafana', 'grafana', 'Grafana', '5.0.0')
.addRequired('panel', 'graph', 'Graph', '5.0.0')
.addRequired('datasource', 'prometheus', 'Prometheus', '5.0.0')
.addRequired('panel', 'singlestat', 'Singlestat', '5.0.0')