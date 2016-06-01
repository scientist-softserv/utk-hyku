export class GraphCountOverTime { 
  constructor(selector, data) {
    $.plot(selector, [ data ], {
      xaxis: {
        mode: 'time',
        minTickSize: [7, 'day']
      },
      yaxis: {
        minTickSize: 1,
        tickDecimals: 0,
        min: 0
      }
    });
  }
}
