import { Controller } from "@hotwired/stimulus";
import { Chart, registerables } from "chart.js";

Chart.register(...registerables);

// Connects to data-controller="chart"
export default class extends Controller {
  static values = {
    config: { type: Object, default: {} },
  };

  connect() {
    const ctx = this.element.getContext("2d");
    this.chart = new Chart(ctx, this.configValue);
  }

  disconnect() {
    this.chart.destroy();
  }
}
