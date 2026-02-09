import CheckboxSelectAll from "@stimulus-components/checkbox-select-all";

// Connects to data-controller="carts--select-all"
export default class extends CheckboxSelectAll {
  static targets = ["selected", "total", "bulkDeleteBtn", "selectAll", "activeCount", "checkoutBtn"];

  connect() {
    super.connect();
    this.initTotalEl = this.totalTarget.innerHTML;
  }

  refresh() {
    const checkboxesCount = this.activeCheckbox.length;
    const checkboxesCheckedCount = this.checked.length;

    if (this.disableIndeterminateValue) {
      this.checkboxAllTarget.checked = checkboxesCheckedCount === checkboxesCount;
    } else {
      this.checkboxAllTarget.checked = checkboxesCheckedCount > 0;
      this.checkboxAllTarget.indeterminate = checkboxesCheckedCount > 0 && checkboxesCheckedCount < checkboxesCount;
    }

    this.selectAllRefresh();
    this.displaySelected();
  }

  toggle(event) {
    event.preventDefault();

    this.checkboxTargets.forEach((checkbox) => {
      checkbox.checked = !checkbox.disabled && event.target.checked;
      this.triggerInputEvent(checkbox);
    });

    this.selectAllRefresh();
    this.displaySelected();
  }

  displaySelected() {
    clearTimeout(this.timeout);
    this.selectedTarget.innerHTML = `Total (${this.checked.length} ${this.checked.length > 1 ? "items" : "item"}):`;
    this.checkoutBtnTarget.disabled = !this.checked.length;

    if (!this.checked.length) {
      this.totalTarget.innerHTML = this.initTotalEl || this.totalTarget.innerHTML;
      this.selectAllTarget.checked = false;
      return;
    }

    this.timeout = setTimeout(() => {
      fetch(this.element.dataset.totalUrl + "?" + this.cartIDSParam, {
        method: "GET",
        headers: {
          Accept: "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
        },
      })
        .then((res) => res.text())
        .then((html) => {
          if (!this.checked.length) return;
          return Turbo.renderStreamMessage(html);
        });
    });
  }

  bulkDelete() {
    if (!this.checked.length || !confirm("Are you sure to delete selected carts?")) return;

    fetch(this.element.dataset.bulkDeleteUrl + "?" + this.cartIDSParam, {
      method: "DELETE",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
      },
    })
      .then((res) => res.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }

  proceedCheckout() {
    if (!this.checked.length) return;

    fetch(this.element.dataset.proceedCheckoutUrl + "?" + this.cartIDSParam, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').getAttribute("content"),
      },
    }).then((res) => Turbo.visit(res.url));
  }

  selectAllRefresh() {
    this.activeCountTarget.innerHTML = `Select All (${this.checked.length})`;
    this.selectAllTarget.checked = this.activeCheckbox.length == this.checked.length;
    this.bulkDeleteBtnTarget.disabled = !this.checked.length;
  }

  selectAllToggle(event) {
    this.toggle(event);
    super.refresh();
  }

  get cartIDSParam() {
    return this.checked.map((el) => `ids[]=` + el.dataset.cartId).join("&");
  }

  get activeCheckbox() {
    return this.checkboxTargets.filter((e) => !e.disabled);
  }
}
