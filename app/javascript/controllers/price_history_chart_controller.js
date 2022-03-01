import { Controller } from '@hotwired/stimulus'

import { Chart, PointElement, LineElement, LineController, LinearScale, TimeScale, Tooltip } from 'chart.js';
import 'chartjs-adapter-luxon'

// Connects to data-controller="price-history-chart"
export default class extends Controller {
  static targets =['canvas']
  static values = { data: Array }

  connect () {
    Chart.register(PointElement, LineElement, LineController, LinearScale, TimeScale, Tooltip)

    const formatter =  new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' })

    const context = this.canvasTarget.getContext('2d')
    new Chart(context, {
      type: 'line',
      data: {
        datasets: [{
          label: 'R$',
          data: this.dataValue,
          stepped: true,
          borderColor: '#ff007d',
          backgroundColor: '#ff007d',
          tension: 1,
          spanGaps: true
        }]
      },
      options: {
        locale: 'pt-BR',
        plugins: {
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            type: 'time',
            time: {
              tooltipFormat: 'dd/MM/yyyy',
              unit: 'day'
            }
          },
          y: {
            ticks: {
              callback: value => formatter.format(value)
            }
          }
        }
      }
    })
  }
}
