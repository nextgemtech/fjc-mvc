import Dropdown from "@stimulus-components/dropdown";

// Connects to data-controller="admin--products--variants--options-dropdown"
export default class extends Dropdown {
  static targets = ["placeholder"];

  connect() {
    super.connect();
  }

  toggle(event) {
    super.toggle();
    console.log("event:", event);
  }

  hide(event) {
    super.hide(event);
  }
}
