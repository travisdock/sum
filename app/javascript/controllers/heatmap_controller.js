import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { data: Object }

  connect() {
    this.renderHeatmap()
  }

  dataValueChanged() {
    this.renderHeatmap()
  }

  renderHeatmap() {
    const svg = this.element.querySelector('#expense-heatmap')
    const data = this.dataValue
    
    if (!data || !data.daily_expenses) return
    
    // Clear existing content
    svg.innerHTML = ''
    
    // Configuration
    const cellSize = 15
    const cellSpacing = 3
    const monthLabelWidth = 30
    const weekdayLabelWidth = 20
    const startX = weekdayLabelWidth + 5
    const startY = monthLabelWidth
    
    // Get the year and create date object for January 1st in local timezone
    const year = parseInt(data.year)
    const yearStart = new Date(year, 0, 1) // January 1st in local timezone
    const yearEnd = new Date(year, 11, 31) // December 31st in local timezone
    
    // Calculate what day of week the year starts on
    const startDayOfWeek = yearStart.getDay() // 0 = Sunday, 1 = Monday, etc.
    
    // Color scale function
    const getColor = (amount) => {
      if (amount === 0) return '#ebedf0'
      const percentage = data.max_expense > 0 ? amount / data.max_expense : 0
      if (percentage <= 0.25) return '#fee'
      if (percentage <= 0.5) return '#fcc'
      if (percentage <= 0.75) return '#f99'
      return '#f66'
    }
    
    // Month labels
    const monthLabels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    const monthPositions = []
    
    // Calculate month label positions
    for (let month = 0; month < 12; month++) {
      const monthStart = new Date(year, month, 1)
      const daysSinceYearStart = Math.floor((monthStart - yearStart) / (24 * 60 * 60 * 1000))
      const monthStartWeek = Math.floor((daysSinceYearStart + startDayOfWeek) / 7)
      monthPositions.push({ month: monthLabels[month], week: monthStartWeek })
    }
    
    // Draw month labels
    monthPositions.forEach(({ month, week }) => {
      const text = document.createElementNS('http://www.w3.org/2000/svg', 'text')
      text.setAttribute('x', startX + week * (cellSize + cellSpacing))
      text.setAttribute('y', 15)
      text.setAttribute('class', 'month-label')
      text.setAttribute('font-size', '12')
      text.setAttribute('fill', '#666')
      text.textContent = month
      svg.appendChild(text)
    })
    
    // Draw weekday labels
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
    weekdays.forEach((day, index) => {
      // Draw all weekday labels to ensure proper alignment
      const text = document.createElementNS('http://www.w3.org/2000/svg', 'text')
      text.setAttribute('x', 5)
      text.setAttribute('y', startY + index * (cellSize + cellSpacing) + 11)
      text.setAttribute('class', 'weekday-label')
      text.setAttribute('font-size', '10')
      text.setAttribute('fill', '#666')
      text.textContent = day.substring(0, 1) // Just show first letter: S, M, T, W, T, F, S
      svg.appendChild(text)
    })
    
    // Draw cells
    let currentDate = new Date(year, 0, 1) // Start from January 1st in local timezone
    let dayIndex = 0
    
    while (currentDate <= yearEnd) {
      // Use local date string to avoid timezone issues
      const year = currentDate.getFullYear()
      const month = String(currentDate.getMonth() + 1).padStart(2, '0')
      const day = String(currentDate.getDate()).padStart(2, '0')
      const dateStr = `${year}-${month}-${day}`
      const dayData = data.daily_expenses[dateStr] || { count: 0, total: 0 }
      
      const dayOfWeek = currentDate.getDay() // 0 = Sunday, 1 = Monday, etc.
      const weekOfYear = Math.floor((dayIndex + startDayOfWeek) / 7)
      
      const x = startX + weekOfYear * (cellSize + cellSpacing)
      const y = startY + dayOfWeek * (cellSize + cellSpacing)
      
      const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect')
      rect.setAttribute('x', x)
      rect.setAttribute('y', y)
      rect.setAttribute('width', cellSize)
      rect.setAttribute('height', cellSize)
      rect.setAttribute('fill', getColor(dayData.total))
      rect.setAttribute('stroke', '#ccc')
      rect.setAttribute('stroke-width', '1')
      rect.setAttribute('rx', '2')
      rect.setAttribute('data-date', dateStr)
      rect.setAttribute('data-amount', dayData.total)
      rect.setAttribute('data-count', dayData.count)
      rect.style.cursor = 'pointer'
      
      // Add hover events
      rect.addEventListener('mouseenter', (e) => {
        const dateStr = e.target.getAttribute('data-date')
        const [year, month, day] = dateStr.split('-').map(num => parseInt(num))
        const date = new Date(year, month - 1, day) // Create date in local timezone
        const amount = parseFloat(e.target.getAttribute('data-amount'))
        const count = parseInt(e.target.getAttribute('data-count'))
        
        tooltip.querySelector('.tooltip-date').textContent = date.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric', year: 'numeric' })
        tooltip.querySelector('.tooltip-amount').textContent = `${count} expense${count !== 1 ? 's' : ''}: $${amount.toFixed(2)}`
        
        const tooltipX = Math.min(x + cellSize + 5, 954 - 160)
        const tooltipY = Math.max(y - 20, 0)
        
        tooltip.setAttribute('transform', `translate(${tooltipX}, ${tooltipY})`)
        tooltip.setAttribute('visibility', 'visible')
      })
      
      rect.addEventListener('mouseleave', () => {
        tooltip.setAttribute('visibility', 'hidden')
      })
      
      svg.appendChild(rect)
      
      currentDate.setDate(currentDate.getDate() + 1)
      dayIndex++
    }
    
    // Create tooltip element (after all cells so it's on top)
    const tooltip = document.createElementNS('http://www.w3.org/2000/svg', 'g')
    tooltip.setAttribute('visibility', 'hidden')
    tooltip.innerHTML = `
      <rect x="0" y="0" width="160" height="40" fill="rgba(0,0,0,0.8)" rx="3" />
      <text x="5" y="15" fill="white" font-size="12" class="tooltip-date"></text>
      <text x="5" y="30" fill="white" font-size="12" class="tooltip-amount"></text>
    `
    svg.appendChild(tooltip)
  }
}