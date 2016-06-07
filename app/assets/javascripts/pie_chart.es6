export class PieChart { 
  constructor(selector, data) {
    this.selector = selector
    this.data = data
  }

  activate() {
    this.plot = $.plot(this.selector, this.data, {
				series: {
					pie: { 
						show: true,
					}
				}
			});
  }

  shutdown() {
    if (typeof this.plot === 'undefined') {
      return
    }
    this.plot.shutdown();
  }
}

