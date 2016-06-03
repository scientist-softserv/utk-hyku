export class GraphCountOverTime { 
  constructor(selector, data) {
    this.selector = selector
    this.data = data
  }

  activate() {
    this.plot = $.plot(this.selector, [ this.data ], {
      xaxis: {
        mode: 'time',
        minTickSize: [7, 'day']
      },
      yaxis: {
        minTickSize: 1,
        tickDecimals: 0,
        min: 0
      }
    })
  }

  shutdown() {
    if (typeof this.plot === 'undefined') {
      return
    }
    this.plot.shutdown();
  }
}
