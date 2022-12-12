export class Ajax {
  constructor(method, url, data, success, fail) {
    this.method = method;
    this.url = url;
    this.data = data;
    this.success = success;
    this.fail = fail;
  }
  execute() {
    $.ajax({
      type: this.method,
      url: this.url,
      data: this.data,
    })
      .done((result) => {
        console.log(result);
      })
      .fail((result) => {
        console.log(result);
      })
      .always(() => {
        console.log("hi");
      });
  }
  try() {
    console.log(this.method);
  }
}
