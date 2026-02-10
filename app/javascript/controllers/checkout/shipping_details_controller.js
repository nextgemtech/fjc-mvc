import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

// Connects to data-controller="checkout--shipping-details"
export default class extends Controller {
  static targets = ["province", "city", "barangay"];

  connect() {
    this.province = new SlimSelect({ select: this.provinceTarget });
    this.city = new SlimSelect({ select: this.cityTarget });
    this.barangay = new SlimSelect({ select: this.barangayTarget });
  }

  provinceChange(e) {
    this.city.disable();
    this.barangay.disable();

    fetch(`/pilipinas/${e.target.value}/cities`, { headers: { Accept: "application/json" } })
      .then((res) => res.json())
      .then((cities) => {
        this.city.setData(cities.map((city) => ({ value: city.name, text: city.name })));
        this.city.enable();
      });
  }

  cityChange(e) {
    this.barangay.disable();

    fetch(`/pilipinas/${e.target.value}/barangays`, { headers: { Accept: "application/json" } })
      .then((res) => res.json())
      .then((brgys) => {
        this.barangay.setData(brgys.map((brgy) => ({ value: brgy.name, text: brgy.name })));
        this.barangay.enable();
      });
  }

  disconnect() {
    this.province.destroy();
    this.city.destroy();
    this.barangay.destroy();
  }
}
