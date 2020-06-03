class Calendar {
  constructor(identifier) {
    this.availableMonths = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    this.available_weel_days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ];
    this.week_days_mobile = ["S", "M", "T", "W", "T", "F", "S"];

    this.noEventMsg = "You have no events for this day.";

    this.x = window.matchMedia("(max-width:800px)");

    this.nrDaysPerWeek = 7;

    this.identifier = identifier;

    /*elements in the html */
    this.elements = {
      days: this.getFirstElementInsideIdByClassName("calendar-days-list"),
      week: this.getFirstElementInsideIdByClassName("calendar-week-list"),
      month: this.getFirstElementInsideIdByClassName("calendar-month"),
      year: this.getFirstElementInsideIdByClassName("calendar-current-year"),
      eventList: this.getFirstElementInsideIdByClassName(
        "current-day-events-list"
      ),
      eventField: this.getFirstElementInsideIdByClassName(
        "add-event-day-field"
      ),
      eventAddBtn: this.getFirstElementInsideIdByClassName(
        "add-event-day-field-btn"
      ),
      currentDay: this.getFirstElementInsideIdByClassName(
        "calendar-left-side-day"
      ),
      currentWeekDay: this.getFirstElementInsideIdByClassName(
        "calendar-left-side-day-of-week"
      ),
      prevYear: this.getFirstElementInsideIdByClassName(
        "calendar-change-year-slider-prev"
      ),
      nextYear: this.getFirstElementInsideIdByClassName(
        "calendar-change-year-slider-next"
      ),
    };

    this.eventList = [
      { title: "test", start_date: "2020-4-3" },
      { title: "anotha one", start_date: "2020-4-4" },
    ]; // no futuro ter aqui JSON.parse para ir buscar os eventos atuais

    this.date = +new Date();
    this.init();
  }

  async init() {
    this.addEventListeners();
    this.drawAll();
    if (!this.identifier.id) return false;

    let id = document.getElementById("calendar-content").dataset.user;
    let url = `/api/users/${id}/events`;

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "X-CSRF-TOKEN": document.querySelector('meta[name="csrf-token"]')
          .content,
      },
    });
    this.eventList = await response.json();
    this.drawEvents();
    console.log(this.eventList);
  }

  addEvent(event) {
    this.eventList.push(event);
  }

  // draw Methods
  drawAll() {
    this.drawWeekDays();
    this.drawMonths();
    this.drawDays();
    this.drawYearAndCurrentDay();
    this.drawEvents();
  }

  drawEvents() {
    let calendar = this.getCalendar();
    let eventList = this.eventList.filter(
      (event) => event.start_date == calendar.active.formatted
    );
    let eventTemplate = "";
    eventList.forEach((item) => {
      eventTemplate += `<li>${item.title}</li>`;
    });
    if (eventList.length == 0) {
      eventTemplate += `<li>${this.noEventMsg}</li>`;
    }
    this.elements.eventList.innerHTML = eventTemplate;
  }

  drawYearAndCurrentDay() {
    let calendar = this.getCalendar();
    this.elements.year.innerHTML = calendar.active.year;
    this.elements.currentDay.innerHTML = calendar.active.day;
    this.elements.currentWeekDay.innerHTML = this.available_weel_days[
      calendar.active.week
    ];
  }

  drawDays() {
    let calendar = this.getCalendar();

    /*last month days that appear*/
    let latestDaysInPrevMonth = this.range(calendar.active.startWeek)
      .map((day, idx) => {
        return {
          dayNumber: this.countOfDaysInMonth(calendar.pMonth) - idx,
          month: new Date(calendar.pMonth).getMonth(),
          year: new Date(calendar.pMonth).getFullYear(),
          currentMonth: false,
        };
      })
      .reverse();

    /*number of days of the month */
    let daysInActiveMonth = this.range(calendar.active.days).map((day, idx) => {
      let dayNumber = idx + 1;
      let today = new Date();
      return {
        dayNumber,
        today:
          today.getDate() === dayNumber &&
          today.getFullYear() === calendar.active.year &&
          today.getMonth() === calendar.active.month,
        month: calendar.active.month,
        year: calendar.active.year,
        selected: calendar.active.day === dayNumber,
        currentMonth: true,
      };
    });

    let left = latestDaysInPrevMonth.length + daysInActiveMonth.length;
    let countOfDays = left;
    if (countOfDays % this.nrDaysPerWeek !== 0)
      countOfDays = left + (this.nrDaysPerWeek - (left % this.nrDaysPerWeek));

    countOfDays -= left;

    let daysInNextMonth = this.range(countOfDays).map((day, idx) => {
      return {
        dayNumber: idx + 1,
        month: new Date(calendar.nMonth).getMonth(),
        year: new Date(calendar.nMonth).getFullYear(),
        currentMonth: false,
      };
    });

    let days = [
      ...latestDaysInPrevMonth,
      ...daysInActiveMonth,
      ...daysInNextMonth,
    ];

    days = days.map((day) => {
      let newDayParams = day;
      let formatted = this.getFormattedDate(
        new Date(`${Number(day.month) + 1}/${day.dayNumber}/${day.year}`)
      );
      newDayParams.hasEvent = this.eventList[formatted];
      return newDayParams;
    });

    let daysTemplate = "";

    for (let i = 0; i < days.length; i++) {
      daysTemplate += "<tr>";
      let j = i;
      for (; j < i + this.nrDaysPerWeek && j < days.length; j++) {
        // console.log(days[j])
        let day = days[j];
        daysTemplate += `<td class=" clickable ${
          day.currentMonth ? "" : "another-month"
        }${day.today ? " active-day " : ""}${
          day.selected ? "selected-day" : ""
        }${day.hasEvent ? " event-day" : ""}" data-day="${
          day.dayNumber
        }" data-month="${day.month}" data-year="${day.year}">${
          days[j].dayNumber
        }</td>`;
      }
      daysTemplate += "</tr>";
      i = j - 1;
    }

    this.elements.days.innerHTML = daysTemplate;
  }

  /*
   *draw months
   * to change the display change the template
   */
  drawMonths() {
    let monthTemplate = "";
    let calendar = this.getCalendar();
    this.availableMonths.forEach((month, idx) => {
      monthTemplate += `<li class="${
        idx === calendar.active.month ? "active" : ""
      }" data-month="${idx}">${month}</li>`;
    });

    this.elements.month.innerHTML = monthTemplate;
  }

  chooseWeekDays(x) {
    let weekTemplate = "";
    let week_var;

    if (x.matches) {
      // If media query matches
      week_var = this.week_days_mobile;
    } else {
      week_var = this.available_weel_days;
    }

    week_var.forEach((week) => {
      weekTemplate += `<th>${week.slice(0, 3)}</th>`;
    });

    this.elements.week.innerHTML = weekTemplate;
  }

  /*
   * draw days of the week
   * to change its appearance change the weekTemplate variable
   */
  drawWeekDays() {
    this.chooseWeekDays(this.x);
  }

  // maybe por em funcoes diferentes ....
  addEventListeners() {
    this.x.addListener(this.chooseWeekDays.bind(this));

    this.elements.prevYear.addEventListener("click", (e) => {
      let calendar = this.getCalendar();
      this.updateTime(calendar.pYear);
      this.drawAll();
    });

    this.elements.nextYear.addEventListener("click", (e) => {
      let calendar = this.getCalendar();
      this.updateTime(calendar.nYear);
      this.drawAll();
    });

    this.elements.month.addEventListener("click", (e) => {
      let calendar = this.getCalendar();
      let month = e.srcElement.getAttribute("data-month");
      if (!month || calendar.active.month == month) return false;

      let newMonth = new Date(calendar.active.tm).setMonth(month);
      this.updateTime(newMonth);
      this.drawAll();
    });

    this.elements.days.addEventListener("click", (e) => {
      let element = e.srcElement;
      let day = element.getAttribute("data-day");
      let month = element.getAttribute("data-month");
      let year = element.getAttribute("data-year");
      if (!day) return false;
      let strDate = `${Number(month) + 1}/${day}/${year}`;
      this.updateTime(strDate);
      this.drawAll();
    });

    /*
        this.elements.eventAddBtn.addEventListener('click', e => {
            let fieldValue = this.elements.eventField.value;
            if (!fieldValue) return false;
            let dateFormatted = this.getFormattedDate(new Date(this.date));
            if (!this.eventList[dateFormatted]) this.eventList[dateFormatted] = [];
            this.eventList[dateFormatted].push(fieldValue);
            //do json.stringify para a  storage
            this.elements.eventField.value = '';
            this.drawAll()
        });*/
  }

  updateTime(time) {
    this.date = +new Date(time);
  }

  getCalendar() {
    let time = new Date(this.date);

    return {
      active: {
        days: this.countOfDaysInMonth(time),
        startWeek: this.getStartedDayOfWeekByTime(time),
        day: time.getDate(),
        week: time.getDay(),
        month: time.getMonth(),
        year: time.getFullYear(),
        formatted: this.getFormattedDate(time),
        tm: +time,
      },
      pMonth: new Date(time.getFullYear(), time.getMonth() - 1, 1),
      nMonth: new Date(time.getFullYear(), time.getMonth() + 1, 1),
      pYear: new Date(new Date(time).getFullYear() - 1, 0, 1),
      nYear: new Date(new Date(time).getFullYear() + 1, 0, 1),
    };
  }

  countOfDaysInMonth(time) {
    let date = this.getMonthAndYear(time);
    return new Date(date.year, date.month + 1, 0).getDate();
  }

  getStartedDayOfWeekByTime(time) {
    let date = this.getMonthAndYear(time);
    return new Date(date.year, date.month, 1).getDay();
  }

  getMonthAndYear(time) {
    let date = new Date(time);
    return {
      year: date.getFullYear(),
      month: date.getMonth(),
    };
  }

  getFormattedDate(date) {
    let month = ("0" + (date.getMonth() + 1)).slice(-2);
    let day = ("0" + date.getDate()).slice(-2);
    return `${date.getFullYear()}-${month}-${day}`;
  }

  range(number) {
    return new Array(number).fill().map((e, i) => i);
  }

  getFirstElementInsideIdByClassName(className) {
    return document
      .getElementById(this.identifier.id)
      .getElementsByClassName(className)[0];
  }
}

let calendar = new Calendar({ id: "calendar" });
let addEventButton = document.getElementById("add-event");
let meeting_button = document.querySelector("label.btn:nth-child(2)");
let personal_button = document.querySelector("label.btn:nth-child(1)");
let project = document.getElementById("project");
let projects_names = [];

meeting_button.addEventListener("click", (event) => {
  event.preventDefault();
  if (
    !meeting_button.classList.contains("active") &&
    project.classList.contains("d-none")
  ) {
    project.classList.remove("d-none");
  }
});

personal_button.addEventListener("click", (event) => {
  event.preventDefault();
  if (
    !personal_button.classList.contains("active") &&
    !project.classList.contains("d-none")
  ) {
    project.classList.add("d-none");
  }
});

function getTypeId(type) {
  if (type === "personal") {
    return document.getElementById("calendar-content").dataset.user;
  } else {
    let ddData = $("#projects_dropdown").data("ddslick");
    return ddData.selectedData === null ? "" : ddData.selectedData.value;
  }
}

addEventButton.addEventListener("click", async (event) => {
  let title = document.getElementById("event-name").value;
  let date = calendar.getCalendar().active.formatted;
  let url = `/api/events`;
  let type = document.querySelector("label.btn.active").querySelector("input")
    .id;
  let sender = document.getElementById("auth-username").dataset.id;

  let id = getTypeId(type);

  console.log("oioioi");

  const response = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-TOKEN": $('meta[name="csrf-token"]').attr("content"),
    },
    body: JSON.stringify({ title, type, date, id, sender }),
  });

  if (response.ok) {
    $("#addEventModal").modal("hide");
    let event = await response.json();
    console.log(event);
    calendar.addEvent(event);
    calendar.drawEvents();
  } else {
    let result = await response.json();

    if (result.errors.title != null) {
      let input = document.querySelector("#event-name");
      addInvalidFeedback(result.errors.title[0]);
      input.classList.add("is-invalid");
    }
  }
});

function addInvalidFeedback(message) {
  let invalid_feedback = document.querySelector(".invalid-feedback");

  if (invalid_feedback !== null) {
    invalid_feedback.textContent = message;
  } else {
    let title_form = document.querySelector("div.form-group:nth-child(1)");
    let node = document.createElement("div");

    node.classList.add("invalid-feedback");
    node.classList.add("d-block");
    node.textContent = message;
    title_form.appendChild(node);
  }
}

function createEventHandler() {
  $("#addEventModal").modal("hide");
  const response = JSON.parse(this.responseText);
  calendar.addEvent(response);
  calendar.drawEvents();
}

// Ajax functions
function encodeForAjax(data) {
  if (data == null) return null;
  return Object.keys(data)
    .map(function (k) {
      return encodeURIComponent(k) + "=" + encodeURIComponent(data[k]);
    })
    .join("&");
}

$("#addEventModal").on("shown.bs.modal", async () => {
  if (projects_names.length === 0) {
    let id = document.getElementById("calendar-content").dataset.user;
    let url = `/api/users/${id}/projects/coordinator`;

    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-TOKEN": $('meta[name="csrf-token"]').attr("content"),
      },
    });

    if (response.ok) {
      let result = await response.json();

      if (result.length === 0) {
        project.innerHTML = `
        <div class="alert alert-warning alert-dismissible fade show" role="alert">
          <strong>No projects were found.</strong> You don't have the privileges to add a meeting to your projects.
          <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        `;
      } else {
        addProjectOptions();
        addProjectsSelect(result);
      }
    } else {
      project.innerHTML = `
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <strong>No projects were found.</strong> You don't have the privileges to add a meeting to your projects.
        <button type="button" class="close" data-dismiss="alert" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      `;
    }
  }
});

function addProjectOptions() {
  project.innerHTML = `
  <div class="form-group">
    <label for="project-name" class="col-form-label"
    >Project</label>
    <div id="projects_dropdown"></div>
  </div>`;
}

function addProjectsSelect(result) {
  let ddData = [];

  result.forEach((elem) => {
    ddData.push({
      text: elem.name,
      value: elem.id,
      selected: false,
      description: `Created by ${elem.username}`,
      imageSrc: `/assets/avatars/${elem.photo_path}.png`,
    });
  });

  $("#projects_dropdown").ddslick({
    data: ddData,
    width: "100%",
    imagePosition: "left",
    selectText: "Select a project",
    onSelected: function (data) {},
  });
}

$("#addEventModal").on("hidden.bs.modal", function () {
  let input = document.querySelector("#event-name");
  input.classList.remove("is-invalid");

  let invalid_feedback = document.querySelector(".invalid-feedback");
  if (invalid_feedback !== null) {
    invalid_feedback.remove();
  }
});
