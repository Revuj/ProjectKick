const task = new Chart(document.getElementById('doughnut-chart-task'), {
  type: 'doughnut',
  data: {
    labels: ['Completed', 'Today', 'Upcoming'],
    datasets: [
      {
        backgroundColor: ['#3e95cd', '#8e5ea2', '#3cba9f'],
        data: [25, 2, 10]
      }
    ]
  },
  options: {
    responsive: true,
    plugins: {
      doughnutlabel: {
        labels: [
          {
            text: 'Tasks',
            font: {
              size: '60'
            }
          },
          {
            text: '37',
            font: {
              size: '50'
            }
          }
        ]
      }
    },
    font: function(context) {
      var width = context.chart.width;
      var size = Math.round(width / 32);
      return {
        size: size,
        weight: 600
      };
    },
    legend: {
      display: false
    }
  }
});

const projects = new Chart(document.getElementById('doughnut-chart-project'), {
  type: 'doughnut',
  data: {
    labels: ['Finished', 'Active'],
    datasets: [
      {
        backgroundColor: ['#3e95cd', '#8e5ea2'],
        data: [2, 24]
      }
    ]
  },
  options: {
    responsive: true,
    plugins: {
      doughnutlabel: {
        labels: [
          {
            text: 'Projects',
            font: {
              size: '60'
            }
          },
          {
            text: '26',
            font: {
              size: '50'
            }
          }
        ]
      }
    },
    font: function(context) {
      var width = context.chart.width;
      var size = Math.round(width / 32);
      return {
        size: size,
        weight: 600
      };
    },
    legend: {
      display: false
    }
  }
});

const activity = new Chart(document.getElementById('bar-chart-activity'), {
  type: 'bar',
  data: {
    labels: [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ],
    datasets: [
      {
        backgroundColor: [
          '#3e95cd',
          '#3e95cd',
          '#3e95cd',
          '#3e95cd',
          '#3e95cd',
          '#3e95cd',
          '#3e95cd'
        ],
        data: [30, 10, 20, 50, 5, 0, 0]
      }
    ]
  },
  options: {
    legend: {
      display: false
    },
    font: function(context) {
      var width = context.chart.width;
      var size = Math.round(width / 32);
      return {
        size: size,
        weight: 600
      };
    }
  }
});

const edit_button = document.querySelector('.edit-button');
const cancel_button = document.querySelector('#cancel');
const update_button = document.querySelector('#update');
const edit_container = document.getElementById('edit');
const details_container = document.getElementById('details');
const user_card = document.querySelector('.col-lg-3 > div:nth-child(1)');

edit_button.addEventListener('click', event => {
  event.preventDefault();
  if (edit_container.classList.contains('d-none')) {
    edit_container.classList.toggle('d-none');
    details_container.classList.toggle('d-none');
  }
});

[cancel_button, update_button].forEach(elem =>
  elem.addEventListener('click', event => {
    event.preventDefault();
    if (details_container.classList.contains('d-none')) {
      edit_container.classList.toggle('d-none');
      details_container.classList.toggle('d-none');
    }
  })
);

user_card.addEventListener('mouseover', event => {
  event.preventDefault();
  user_card.querySelector('.edit-button').classList.remove('d-none');
});

user_card.addEventListener('mouseleave', event => {
  event.preventDefault();
  user_card.querySelector('.edit-button').classList.add('d-none');
});
