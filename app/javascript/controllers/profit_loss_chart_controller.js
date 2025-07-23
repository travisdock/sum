import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { data: Array }

  async connect() {
    await this.initializeChart()
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
    }
  }

  async initializeChart() {
    // Dynamic import Chart.js
    const { Chart, registerables } = await import('chart.js')
    Chart.register(...registerables)
    
    const ctx = this.element.getContext('2d')
    
    const labels = this.dataValue.map(item => item.month)
    const profitLossData = this.dataValue.map(item => item.profit_loss)
    
    // Generate colors - green for profit, red for loss
    const backgroundColors = profitLossData.map(value => 
      value >= 0 ? 'rgba(75, 192, 192, 0.6)' : 'rgba(255, 99, 132, 0.6)'
    )
    const borderColors = profitLossData.map(value => 
      value >= 0 ? 'rgba(75, 192, 192, 1)' : 'rgba(255, 99, 132, 1)'
    )

    this.chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'Profit/Loss',
          data: profitLossData,
          backgroundColor: backgroundColors,
          borderColor: borderColors,
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: function(value, index, values) {
                return '$' + value.toLocaleString()
              }
            }
          }
        },
        plugins: {
          tooltip: {
            callbacks: {
              label: function(context) {
                const value = context.parsed.y
                const label = value >= 0 ? 'Profit' : 'Loss'
                return label + ': $' + Math.abs(value).toLocaleString()
              }
            }
          },
          legend: {
            display: false
          }
        }
      }
    })
  }
}