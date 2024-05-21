$("#menu-1").on("click", () => {
  $(".main-menu").hide();
  $(".menu-1").show();
  $(".nav-link").removeClass("active");
  $("#menu-1").addClass("active");
});
$("#menu-2").on("click", () => {
  $(".main-menu").hide();
  $(".menu-2").show();
  $(".nav-link").removeClass("active");
  $("#menu-2").addClass("active");
});
const swiperDataEnter = async (spwanData) => {
  let a = 0;
  let swiperData = "";
  while (a < spwanData.length) {
    swiperData =
      swiperData +
      `<div class="swiper-slide">
        <div class="spawn-main">
          <div class="number-counter">${a + 1}</div>
          <div class="image">
            <img src="${spwanData[a].photo_url}" alt="" />
          </div>
          <div class="bottom-main">
            <div class="title">${spwanData[a].label}</div>
            <button id="firstSpawn" onclick="spawnNow(${a + 1})">
              Spawn
            </button>
          </div>
        </div>
      </div>`;
    a++;
  }
  $(".swiper-wrapper").html(swiperData);
};
$(".main-div").hide();
window.addEventListener("message", function (event) {
  let data = event.data;
  let spwanData = event.data.data;
  let playerNew = event.data.playerNew;
  console.log(playerNew);
  if (playerNew) {
    // $("#lastLocation").removeClass("disabled");
  } else {
    // $("#lastLocation").addClass("disabled");
  }

  swiperDataEnter(spwanData);
  if (data.type == "show") {
    $(".main-div").hide();
    $(".main-div").show();
  }
  $(window).on("keydown", function (event) {
    if (event.which == 27) {
      $.post("http://bw-spawn/closeUI", JSON.stringify({}));
      $(".main-div").hide();
    }
  });
});

const spawnNow = (data) => {
  $.post(
    "http://bw-spawn/spawnNow",
    JSON.stringify({
      spawn: data,
    })
  );
  $(".main-div").hide();
};
