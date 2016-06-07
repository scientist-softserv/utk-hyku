export class StatisticsTabManager { 
  constructor(collection_data, work_data, work_by_type_data) {
    var over_time = require('graph_count_over_time');
    this.collection = new over_time.GraphCountOverTime('#collection-graph', collection_data);
    this.work = new over_time.GraphCountOverTime('#works-graph', work_data);

    var pie = require('pie_chart');
    this.work_types = new pie.PieChart('#works-by-type', work_by_type_data);

    this.activate();
  }

  // Flot won't initialize unless the graph container is visible. So activate the
  // graph on tab switch
  activate() {
    this.show("#collections")
    $('a[data-toggle="tab"]').on('hide.bs.tab', e => {
      this.hide($(e.target).attr("href"));
    });

    $('#statistics-tabs a').click(function (e) {
      e.preventDefault()
      $(this).tab('show')
    })

    $('#statistics-tabs a[data-toggle="tab"]').on('shown.bs.tab', e => {
      this.show($(e.target).attr("href"));
    });
  }

  hide(target) {
    if (target == '#works') {
      this.work.shutdown();
      this.work_types.shutdown();
    } else if (target == '#collections') {
      this.collection.shutdown();
    }
    return true;
  }

  show(target) {
    if (target == '#works') {
      this.work.activate();
      this.work_types.activate();
    } else if (target == '#collections') {
      this.collection.activate();
    }
  }
}
