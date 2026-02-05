# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin 'intl-tel-input', to: 'https://ga.jspm.io/npm:intl-tel-input@18.2.1/index.js'
pin "stimulus-notification" # @2.2.0
pin "hotkeys-js" # @3.13.7
pin "stimulus-use" # @0.52.2
pin "stimulus-rails-autosave" # @5.1.0,
pin "@stimulus-components/dialog", to: "@stimulus-components--dialog.js" # @1.0.1
pin "js-image-zoom" # @0.7.0
pin "@stimulus-components/popover", to: "@stimulus-components--popover.js" # @7.0.0
pin "@stimulus-components/sortable", to: "@stimulus-components--sortable.js" # @5.0.1
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.8
pin "sortablejs" # @1.15.2
pin "slim-select" # @2.8.2
pin "@stimulus-components/checkbox-select-all", to: "@stimulus-components--checkbox-select-all.js" # @6.0.0
pin "@stimulus-components/dropdown", to: "@stimulus-components--dropdown.js" # @3.0.0
pin "@stimulus-components/password-visibility", to: "@stimulus-components--password-visibility.js" # @3.0.0
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "chart.js", to: "https://ga.jspm.io/npm:chart.js@4.4.1/dist/chart.js"
pin "@kurkle/color", to: "https://ga.jspm.io/npm:@kurkle/color@0.3.2/dist/color.esm.js"
