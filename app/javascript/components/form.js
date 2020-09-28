// target class: a-card 
const setUpMeetingButtons = document.querySelectorAll(".a-card");
const cartHeader = document.querySelector("#cart-header");
const selectedDates = document.querySelector(".selected-dates");
// const cartSubmitButton = document.getElementById("cart-submit");



const initRemoveElement = () => {
  const removalLinks = document.querySelectorAll(".remove-selected-date");
  removalLinks.forEach((element) => {
    element.addEventListener("click", (event) => {
      event.preventDefault();
      element.parentNode.parentNode.remove();
      if (document.querySelectorAll(".remove-selected-date").length === 0) { cartHeader.classList.add("hide"); }
      setUpMeetingButtons.forEach((linkTag) => {
        if (linkTag.search.slice(17) == element.parentElement.parentElement.querySelector(".availability-id").value) {
          linkTag.parentElement.parentElement.parentElement.classList.remove("hide");
        }
      });
    });
  });
 
};

const initInsertItemtoCart = () => {
  setUpMeetingButtons.forEach((button) => {
    button.addEventListener("click", (event) => {
      event.preventDefault();

      if (selectedDates.innerText === "") { cartHeader.classList.remove("hide"); }
      fetch(`meetings/new/${event.target.search}`)
        .then(response => response.text())
        .then((data) => {
          selectedDates.insertAdjacentHTML("beforeend", data);
          initRemoveElement();
          event.target.offsetParent.classList.add("hide")
        });
    });
  });
};

// const initUrlParams = () => {
//   new URLSearchParams(window.location.search);
//   return urlParams.get('js') === "true"
// };

// const initCopyCartItems = () => {
//   cartSubmitButton.addEventListener("click", (event) => {
//     return document.querySelectorAll(".cart-item");
//   });
// };

// const insertCartItems = (cartItems) => {
//   cartItems.forEach((item) => {
//     selectedDates.insertAdjacentHTML("beforeend", item.outerHTML);
//   });
//   initRemoveElement();
// };


export { initInsertItemtoCart }



