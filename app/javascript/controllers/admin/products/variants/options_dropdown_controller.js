import Dropdown from "@stimulus-components/dropdown";

// Connects to data-controller="admin--products--variants--options-dropdown"
export default class extends Dropdown {
  static targets = ["placeholder", "optionTemplate", "optionInput", "optionBtn", "povField", "optionContainer"];

  connect() {
    super.connect();
  }

  toggle() {
    super.toggle();
  }

  selectOption(event) {
    this.toggle();
    this.placeholderTarget.innerHTML = event.target.dataset.povName;
    this.povFieldTarget.value = event.target.dataset.povId;
    this.placeholderTarget.classList.remove("text-gray-500");
  }

  hide(event) {
    super.hide(event);
  }

  addEvent(event) {
    if (event.key === "Enter" || event.type === "click") {
      event.preventDefault();

      if (this.optionInputTarget.value) {
        this.createProductOptionValue();
      }
    }
  }

  createProductOptionValue() {
    let isError = false;

    const formData = new FormData();
    formData.append("product_option_value[name]", this.optionInputTarget.value);
    formData.append("product_option_value[product_option_id]", this.element.dataset.poId);

    fetch(this.element.dataset.createProductOptionValueUrl, {
      method: "POST",
      body: formData,
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
      },
    })
      .then((response) => {
        if (!response.ok) isError = true;
        return response.json();
      })
      .then((data) => {
        if (!isError) this.appendPovOption(data);
      });
  }

  appendPovOption(pov) {
    const template = this.optionTemplateTarget.content.cloneNode(true);
    const element = template.firstElementChild;

    element.dataset.povId = pov.id;
    element.dataset.povName = pov.name;

    template.querySelector("[option-placeholder]").textContent = this.optionInputTarget.value;

    this.optionContainerTarget.appendChild(template);
    this.optionInputTarget.value = "";
  }
}
