import { Controller } from "@hotwired/stimulus";
import intlTelInput from "intl-tel-input";
import utilsScript from "intl-tel-input/build/js/utils.js?url";

// Connects to data-controller="phone"
export default class extends Controller {
  static targets = ["input", "hidden"];

  connect() {
    const COUNTRY = "PH";

    this.iti = intlTelInput(this.inputTarget, {
      utilsScript,
      separateDialCode: true,
      initialCountry: COUNTRY,
      allowDropdown: false,
      preferredCountries: [COUNTRY],
      onlyCountries: [COUNTRY],
      customPlaceholder: (placeholder) => "e.g. " + placeholder,
    });
  }

  telHiddenInput() {
    this.hiddenTarget.value = this.iti.getNumber();
  }
}
