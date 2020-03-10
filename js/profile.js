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
    title: {
      display: true,
      text: 'Tasks'
    },
    responsive: true
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
    title: {
      display: true,
      text: 'Project'
    }
  }
});

const activity = new Chart(document.getElementById('bar-chart-activity'), {
  type: 'bar',
  data: {
    labels: ['Africa', 'Asia', 'Europe'],
    datasets: [
      {
        label: 'Population (millions)',
        backgroundColor: ['#3e95cd', '#8e5ea2', '#3cba9f'],
        data: [2478, 5267, 734]
      }
    ]
  },
  options: {
    legend: {
      display: false
    },
    title: {
      display: true,
      text: 'Predicted world population (millions) in 2050'
    }
  }
});

const edit_button = document.querySelector('.edit-button');
const cancel_button = document.querySelector('#cancel');
const update_button = document.querySelector('#update');
const edit_container = document.getElementById('edit');
const details_container = document.getElementById('details');

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
