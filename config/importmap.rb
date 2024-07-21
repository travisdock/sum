# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/plugins", under: "plugins"

# Chartkick
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
pin "@stimulus-components/notification", to: "@stimulus-components--notification.js" # @3.0.0
pin "stimulus-use" # @0.52.2
