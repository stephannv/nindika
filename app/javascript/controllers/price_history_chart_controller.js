import { Controller } from 'stimulus'

import ApexCharts from 'apexcharts'
import ptBr from 'apexcharts/dist/locales/pt-br.json'

export default class extends Controller {
  static values = { data: Array }

  connect () {
    const formatter = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' })
    const chart = new ApexCharts(this.element, {
      chart: {
        type: 'line',
        fontFamily: 'Inter, sans-serif',
        locales: [ptBr],
        defaultLocale: 'pt-br',
        toolbar: { show: false },
        zoom: { enabled: false },
        height: '100%'
      },
      series: [{
        name: 'Preço',
        data: this.dataValue
      }],
      stroke: {
        curve: 'stepline'
      },
      colors:['#00c4ff'],
      tooltip: {
        enabled: true,
        x: {
          show: true,
          formatter: (value) => new Date(value).toLocaleDateString('pt-BR')
        },
      },
      xaxis: {
        type: 'datetime'
      },
      yaxis: {
        labels: {
          formatter: (value) => formatter.format(value)
        }
      },
    })
    chart.render()
  }
}
