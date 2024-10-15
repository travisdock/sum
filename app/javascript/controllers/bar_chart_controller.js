import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="bar-chart"
export default class extends Controller {
  static values = { profitLoss: Object }
  static targets = ['context']

  connect() {
    var colors = []
    Object.values(this.profitLossValue).forEach((value) => {
      if (value > 0) {
        colors.push('green')
      } else {
        colors.push('red')
      }
    })
    const data = {
      labels: Object.keys(this.profitLossValue),
      datasets: [
        {
          label: 'Profit',
          data: Object.values(this.profitLossValue),
          backgroundColor: colors,
          borderColor: "white",
          borderWidth: 1
        }
      ]
    }
    const config = {
      type: 'bar',
      data: data,
    }
    const ctx = this.contextTarget
    new Chart(ctx, config)
  }
}
