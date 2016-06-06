export class Graph { 
  constructor(selector, data, options) {
    this.selector = selector
    this.data = data
    this.options = options;
  }

  activate() {
    this.plot = $.plot(this.selector, this.data, this.options);
  }

  shutdown() {
    if (typeof this.plot === 'undefined') {
      return
    }
    this.plot.shutdown();
  }
}
