export default class FlashMessage {
  constructor(flashType, header, messages) {
    this.flashType = flashType;
    this.header = header;
    this.messages = messages;
    this.flashContainerSelector = '[data-flash]';
  }

  showFlash() {
    this.flashContainer().html(`
      <div class="ui message ${this.flashType}">
        <div class="header">
          ${this.header}
        </div>
        ${this.messageList()}
      </div>
    `);
  }

  showSimpleMessage() {
    this.flashContainer().html(`
      <div class="ui message ${this.flashType}">
        ${this.messages}
      </div>
    `);
  }

  messageList() {
    if (this.messages.length) {
      return (
        `<ul>
          ${this.listItems()}
        </ul>`
      );
    }
    return '';
  }

  listItems() {
    return this.messages.map((message) => `<li>${message}</li>`);
  }

  clearFlash() {
    this.flashContainer().empty();
  }

  flashContainer() {
    return $(this.flashContainerSelector);
  }
}
