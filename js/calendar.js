
class Calendar {

    constructor(identifier) {

        this.availableMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        this.available_weel_days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

        this.noEventMsg = 'No Events. Do you want to add some?';

        this.nrDaysPerWeek = 7;

        this.identifier = identifier;

        /*elements in the html */
        this.elements = {
            days: this.getFirstElementInsideIdByClassName('calendar-days-list'),
            week: this.getFirstElementInsideIdByClassName('calendar-week-list'),
            month: this.getFirstElementInsideIdByClassName('calendar-month'),
            year: this.getFirstElementInsideIdByClassName('calendar-current-year'),
            eventList: this.getFirstElementInsideIdByClassName('current-day-events-list'),
            eventField: this.getFirstElementInsideIdByClassName('add-event-day-field'),
            eventAddBtn: this.getFirstElementInsideIdByClassName('add-event-day-field-btn'),
            currentDay: this.getFirstElementInsideIdByClassName('calendar-left-side-day'),
            currentWeekDay: this.getFirstElementInsideIdByClassName('calendar-left-side-day-of-week'),
            prevYear: this.getFirstElementInsideIdByClassName('calendar-change-year-slider-prev'),
            nextYear: this.getFirstElementInsideIdByClassName('calendar-change-year-slider-next')
        };

        this.eventList = {}; // no futuro ter aqui JSON.parse para ir buscar os eventos atuais

        this.date = +new Date();
        this.init();
    }

    init() {
        if (!this.identifier.id) return false;
        this.addEventListeners();
        this.drawAll();
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
        let eventList = this.eventList[calendar.active.formatted] || [this.noEventMsg];
        let eventTemplate = "";
        eventList.forEach(item => {
            eventTemplate += `<li>${item}</li>`;
        });

        this.elements.eventList.innerHTML = eventTemplate;
    }

    drawYearAndCurrentDay() {
        let calendar = this.getCalendar();
        this.elements.year.innerHTML = calendar.active.year;
        this.elements.currentDay.innerHTML = calendar.active.day;
        this.elements.currentWeekDay.innerHTML = this.available_weel_days[calendar.active.week];
    }

    drawDays() {
        let calendar = this.getCalendar();

        /*last month days that appear*/
        let latestDaysInPrevMonth = this.range(calendar.active.startWeek).map((day, idx) => {
            return {
                dayNumber: this.countOfDaysInMonth(calendar.pMonth) - idx,
                month: new Date(calendar.pMonth).getMonth(),
                year: new Date(calendar.pMonth).getFullYear(),
                currentMonth: false
            }
        }).reverse();


        /*number of days of the month */
        let daysInActiveMonth = this.range(calendar.active.days).map((day, idx) => {
            let dayNumber = idx + 1;
            let today = new Date();
            return {
                dayNumber,
                today: today.getDate() === dayNumber && today.getFullYear() === calendar.active.year && today.getMonth() === calendar.active.month,
                month: calendar.active.month,
                year: calendar.active.year,
                selected: calendar.active.day === dayNumber,
                currentMonth: true
            }
        });


       let left = (latestDaysInPrevMonth.length + daysInActiveMonth.length ) 
       let countOfDays = left;
       if (countOfDays %  this.nrDaysPerWeek !== 0)
        countOfDays =  left + ( this.nrDaysPerWeek - left %  this.nrDaysPerWeek);

        countOfDays-=left;

        let daysInNextMonth = this.range(countOfDays).map((day, idx) => {
            return {
                dayNumber: idx + 1,
                month: new Date(calendar.nMonth).getMonth(),
                year: new Date(calendar.nMonth).getFullYear(),
                currentMonth: false
            }
        });
      

        let days = [...latestDaysInPrevMonth, ...daysInActiveMonth, ...daysInNextMonth];

        days = days.map(day => {
            let newDayParams = day;
            let formatted = this.getFormattedDate(new Date(`${Number(day.month) + 1}/${day.dayNumber}/${day.year}`));
            newDayParams.hasEvent = this.eventList[formatted];
            return newDayParams;
        });

        let daysTemplate = "";


        for(let i = 0; i < days.length; i++) {

            daysTemplate += "<tr>";
            let j = i;
            for(; j < i +  this.nrDaysPerWeek && j < days.length ; j++) {
               // console.log(days[j])
                let day = days[j];
                daysTemplate += `<td class=" clickable ${day.currentMonth ? '' : 'another-month'}${day.today ? ' active-day ' : ''}${day.selected ? 'selected-day' : ''}${day.hasEvent ? ' event-day' : ''}" data-day="${day.dayNumber}" data-month="${day.month}" data-year="${day.year}">${days[j].dayNumber}</td>`
            }
            daysTemplate+="</tr>";
            i=j-1;
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
            monthTemplate += `<li class="${idx === calendar.active.month ? 'active' : ''}" data-month="${idx}">${month}</li>`
        });

        this.elements.month.innerHTML = monthTemplate;
    }

    /*
    * draw days of the week
    * to change its appearance change the weekTemplate variable
    */
    drawWeekDays() {
        let weekTemplate = "";
        this.available_weel_days.forEach(week => {
            weekTemplate += `<th>${week.slice(0, 3)}</th>`
        });

        this.elements.week.innerHTML = weekTemplate;
    }

    // maybe por em funcoes diferentes ....
    addEventListeners() {
        this.elements.prevYear.addEventListener('click', e => {
            let calendar = this.getCalendar();
            this.updateTime(calendar.pYear);
            this.drawAll()
        });

        this.elements.nextYear.addEventListener('click', e => {
            let calendar = this.getCalendar();
            this.updateTime(calendar.nYear);
            this.drawAll()
        });

        this.elements.month.addEventListener('click', e => {
            let calendar = this.getCalendar();
            let month = e.srcElement.getAttribute('data-month');
            if (!month || calendar.active.month == month) return false;

            let newMonth = new Date(calendar.active.tm).setMonth(month);
            this.updateTime(newMonth);
            this.drawAll()
        });


        this.elements.days.addEventListener('click', e => {
            let element = e.srcElement;
            let day = element.getAttribute('data-day');
            let month = element.getAttribute('data-month');
            let year = element.getAttribute('data-year');
            if (!day) return false;
            let strDate = `${Number(month) + 1}/${day}/${year}`;
            this.updateTime(strDate);
            this.drawAll()
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
                tm: +time
            },
            pMonth: new Date(time.getFullYear(), time.getMonth() - 1, 1),
            nMonth: new Date(time.getFullYear(), time.getMonth() + 1, 1),
            pYear: new Date(new Date(time).getFullYear() - 1, 0, 1),
            nYear: new Date(new Date(time).getFullYear() + 1, 0, 1)
        }
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
            month: date.getMonth()
        }
    }

    getFormattedDate(date) {
        return `${date.getDate()}/${date.getMonth()}/${date.getFullYear()}`;
    }

    range(number) {
        return new Array(number).fill().map((e, i) => i);
    }

    getFirstElementInsideIdByClassName(className) {
        return document.getElementById(this.identifier.id).getElementsByClassName(className)[0];
    }
}


(function () {
    new Calendar({
        id: "calendar"
    })
})();
