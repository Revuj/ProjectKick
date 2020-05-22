document.addEventListener('DOMContentLoaded', build);

const update_projectNr = document.getElementById('project-update')
const update_taskNr = document.getElementById('task-update');
const update_userNr = document.getElementById('user-update');
const update_reportNr = document.getElementById('report-update');

let nr_projetcs = document.getElementById('number-projects');
let nr_tasks = document.getElementById('number-tasks');
let nr_users = document.getElementById('number-users');
let nr_reports = document.getElementById('number-reports');


const btn_yearStats = document.getElementById('year-stats');
const btn_teamSize  = document.getElementById('team-size');

const stats = document.getElementById('stats');
const round_chart = document.getElementById('round-chart');

btn_yearStats.addEventListener('click', (e) => {
  e.preventDefault();
  stats.classList.remove('d-none');
  round_chart.classList.add('d-none');
  
  btn_teamSize.classList.add('secondary-button');
  btn_teamSize.classList.remove('primary-button');
  btn_yearStats.classList.remove('secondary-button');
  btn_yearStats.classList.add('primary-button');
  

});

btn_teamSize.addEventListener('click', (e)=> {
  e.preventDefault();
  stats.classList.add('d-none');
  round_chart.classList.remove('d-none');

  btn_yearStats.classList.remove('primary-button');
  btn_yearStats.classList.add('secondary-button');

  btn_teamSize.classList.remove('secondary-button');
  btn_teamSize.classList.add('primary-button');
})


update_projectNr.addEventListener('click', () => {
  animation360deg(update_projectNr.querySelector('.reload'), 1000);
  let init = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/fetchNrProject`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('message' in data) {
            alert(response['message']);
          }
          else {
            console.log(data);
            nr_projetcs.innerText = data[0];
          }
        })
      }
      else {
        console.log('Network response was not ok.');
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

});

update_taskNr.addEventListener('click', () => {
  animation360deg(update_taskNr.querySelector('.reload'), 1000);

  let init = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/fetchNrTasks`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('message' in data) {
            alert(response['message']);
          }
          else {
            console.log(data);
            nr_tasks.innerText = data[0];
          }
        })
      }
      else {
        console.log('Network response was not ok.');
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });


});

update_userNr.addEventListener('click', () => {
  animation360deg(update_userNr.querySelector('.reload'), 1000);
  let init = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/fetchNrUsers`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('message' in data) {
            alert(response['message']);
          }
          else {
            console.log(data);
            nr_users.innerText = data[0];
          }
        })
      }
      else {
        console.log('Network response was not ok.');
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

});

update_reportNr.addEventListener('click', () => {
  animation360deg(update_reportNr.querySelector('.reload'), 1000);

  let init = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/fetchNrReports`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('message' in data) {
            alert(response['message']);
          }
          else {
            console.log(data);
            nr_reports.innerText = data[0];
          }
        })
      }
      else {
        console.log('Network response was not ok.');
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

});

async function getCountries() {

  let init = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/countries`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('message' in data) {
            alert(response['message']);
          }
          else {
            const countries = data[0];
            loadMapCountryDensity(countries);

          }
        })
      }
      else {
        console.log('Network response was not ok.');
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

}




function animation360deg(element, duration) {
  element.animate([
    { transform: 'rotateZ(0deg)' },
    { transform: 'rotateZ(360deg)' }
  ], { duration: duration });
}

function build() {
  getCountries();
  getTeamSize();
  getIntelPerMonth();
  //getBannedUsers();
  //getRecentUsers();

}

async function getTeamSize() {
  let init = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/fetchTeamBySize`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('message' in data) {
            alert(response['message']);
          }
          else {
            loadCicularGraphTeam(data[0]);
          }
        })
      }
      else {

        console.log('Network response was not ok.' + JSON.stringify(data));
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

}


async function getIntelPerMonth() {
  let init = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/monthlyIntel`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('message' in data) {
            alert(response['message']);
          }
          else {
            const [issues, projects, users] = data;
            loadMonthlyCharts(issues, projects, users)
          }
        })
      }
      else {

        console.log('Network response was not ok.' + JSON.stringify(data));
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

}

async function getBannedUsers() {
  let init = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/bannedUsers`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('message' in data) {
            alert(response['message']);
          }
          else {
            console.log(data);
          }
        })
      }
      else {

        console.log('Network response was not ok.' + JSON.stringify(data));
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

}

async function getRecentUsers() {
  let init = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
    },
  }

  fetch(`/admin/recentUsers`, init)
    .then(function (response) {
      if (response.ok) {
        response.json().then(data => {
          if ('message' in data) {
            alert(response['message']);
          }
          else {
            console.log(data);
          }
        })
      }
      else {

        console.log('Network response was not ok.' + JSON.stringify(data));
      }
    }).catch(function (error) {
      console.log('There has been a problem with your fetch operation: ' + error.message);
    });

}


function loadMonthlyCharts(issues, projects, users) {



  let project = [];

  for (let i = 1; i <= 12; i++) {
    const x =  projects.find(u => { return u['month'] === i.toString()});
    if (x === undefined) project.push(0); else project.push(x['total'])  
  }

  projects.forEach(elem => project.push(elem['total']));

  let issue = [];
  for (let i = 1; i <= 12; i++) {
    const x =  issues.find(u => { return u['month'] === i.toString()});
    if (x === undefined) issue.push(0); else issue.push(x['total'])  
  }

  let user = []
  for (let i = 1; i <= 12; i++) {
    const x =  users.find(u => { return u['month'] === i.toString();});
    if (x === undefined) user.push(0); else user.push(x['total'])
  }




  new Chart(document.getElementById('line-chart'), {
    type: 'line',
    data: {
      labels: [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ],
      datasets: [
        {
          data: project,
          label: 'Number of project',
          borderColor: '#3e95cd',
          backgroundColor: 'rgba(1,181,198,0.2)',
          fill: true
        },
        {
          data: issue,
          label: 'Tasks done',
          borderColor: '#8e5ea2',
          backgroundColor: 'rgba(179,181,198,0.2)',

          fill: true
        },
        {
          data: user,
          label: 'Number of new users',
          borderColor: '#3cba9f',
          backgroundColor: 'rgba(1,81,198,0.2)',

          fill: true
        }
      ]
    },
    options: {
      aspectRatio: 2.5,

      title: {
        display: true,
        text: 'Numbers last 12 months'
      },

      legend: {
        display: true,
        align:'center',
        position:'left',
      }
    }
  });
}

function loadCicularGraphTeam(groups) {
  new Chart(document.getElementById('doughnut-chart'), {
    type: 'doughnut',
    data: {
      labels: ['Small Teams (< 5)', 'Medium Teams (5-20)', 'Big teams (> 20)'],
      datasets: [
        {
          backgroundColor: ['#3e95cd', '#8e5ea2', '#3cba9f'],
          data: [groups['small'], groups['medium'], groups['large']]
        }
      ]
    },
    options: {
      aspectRatio: 2.5,
      title: {
        display: true,
        text: 'Current number of teams per size',
        padding: 25
      },

      plugins: {
        doughnutlabel: {
          labels: [
            {
              text: 'Teams Size',
              font: {
                size: '30'
              }
            }
          ]
        }
      },
      font: function (context) {
        return {
          size: 300,
          weight: 500
        };
      },
      legend: {
        display: true,
        position :'left',
        fontSize: 30,
        padding: 35
      }
    }
  });
}

function loadMapCountryDensity(countries) {
  am4core.ready(function () {
    // Themes begin
    am4core.useTheme(am4themes_animated);
    // Themes end

    // Create map instance
    let chart = am4core.create('chartdiv', am4maps.MapChart);

    let label = chart.chartContainer.createChild(am4core.Label);
    label.text = 'User Distribution';
    label.align = 'left';

    let mapData = []

    countries.forEach(country => {
      mapData.push({ id: country.name, name: country.name, value: country.total, color: chart.colors.getIndex(0) })
    })

    /*
    let mapData = [
      {
        id: 'AF',
        name: 'Afghanistan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'AL',
        name: 'Albania',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'DZ',
        name: 'Algeria',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'AO',
        name: 'Angola',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'AR',
        name: 'Argentina',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'AM',
        name: 'Armenia',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      { id: 'AU', name: 'Australia', value: 0, color: '#8aabb0' },
      {
        id: 'AT',
        name: 'Austria',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'AZ',
        name: 'Azerbaijan',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'BH',
        name: 'Bahrain',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'BD',
        name: 'Bangladesh',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'BY',
        name: 'Belarus',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'BE',
        name: 'Belgium',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'BJ',
        name: 'Benin',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'BT',
        name: 'Bhutan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'BO',
        name: 'Bolivia',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'BA',
        name: 'Bosnia and Herzegovina',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'BW',
        name: 'Botswana',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'BR',
        name: 'Brazil',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'BN',
        name: 'Brunei',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'BG',
        name: 'Bulgaria',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'BF',
        name: 'Burkina Faso',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'BI',
        name: 'Burundi',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'KH',
        name: 'Cambodia',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'CM',
        name: 'Cameroon',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'CA',
        name: 'Canada',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'CV',
        name: 'Cape Verde',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'CF',
        name: 'Central African Rep.',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'TD',
        name: 'Chad',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'CL',
        name: 'Chile',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'CN',
        name: 'China',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'CO',
        name: 'Colombia',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'KM',
        name: 'Comoros',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'CD',
        name: 'Congo, Dem. Rep.',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'CG',
        name: 'Congo, Rep.',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'CR',
        name: 'Costa Rica',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'CI',
        name: "Cote d'Ivoire",
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'HR',
        name: 'Croatia',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'CU',
        name: 'Cuba',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'CY',
        name: 'Cyprus',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'CZ',
        name: 'Czech Rep.',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'DK',
        name: 'Denmark',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'DJ',
        name: 'Djibouti',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'DO',
        name: 'Dominican Rep.',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'EC',
        name: 'Ecuador',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'EG',
        name: 'Egypt',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'SV',
        name: 'El Salvador',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'GQ',
        name: 'Equatorial Guinea',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'ER',
        name: 'Eritrea',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'EE',
        name: 'Estonia',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'ET',
        name: 'Ethiopia',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      { id: 'FJ', name: 'Fiji', value: 0, color: '#8aabb0' },
      {
        id: 'FI',
        name: 'Finland',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'FR',
        name: 'France',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'GA',
        name: 'Gabon',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'GM',
        name: 'Gambia',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'GE',
        name: 'Georgia',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'DE',
        name: 'Germany',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'GH',
        name: 'Ghana',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'GR',
        name: 'Greece',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'GT',
        name: 'Guatemala',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'GN',
        name: 'Guinea',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'GW',
        name: 'Guinea-Bissau',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'GY',
        name: 'Guyana',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'HT',
        name: 'Haiti',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'HN',
        name: 'Honduras',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'HK',
        name: 'Hong Kong, China',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'HU',
        name: 'Hungary',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'IS',
        name: 'Iceland',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'IN',
        name: 'India',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'ID',
        name: 'Indonesia',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'IR',
        name: 'Iran',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'IQ',
        name: 'Iraq',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'IE',
        name: 'Ireland',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'IL',
        name: 'Israel',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'IT',
        name: 'Italy',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'JM',
        name: 'Jamaica',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'JP',
        name: 'Japan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'JO',
        name: 'Jordan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'KZ',
        name: 'Kazakhstan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'KE',
        name: 'Kenya',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'KP',
        name: 'Korea, Dem. Rep.',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'KR',
        name: 'Korea, Rep.',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'KW',
        name: 'Kuwait',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'KG',
        name: 'Kyrgyzstan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      { id: 'LA', name: 'Laos', value: 0, color: chart.colors.getIndex(0) },
      {
        id: 'LV',
        name: 'Latvia',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'LB',
        name: 'Lebanon',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'LS',
        name: 'Lesotho',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'LR',
        name: 'Liberia',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'LY',
        name: 'Libya',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'LT',
        name: 'Lithuania',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'LU',
        name: 'Luxembourg',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'MK',
        name: 'Macedonia, FYR',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'MG',
        name: 'Madagascar',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'MW',
        name: 'Malawi',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'MY',
        name: 'Malaysia',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'ML',
        name: 'Mali',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'MR',
        name: 'Mauritania',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'MU',
        name: 'Mauritius',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'MX',
        name: 'Mexico',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'MD',
        name: 'Moldova',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'MN',
        name: 'Mongolia',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'ME',
        name: 'Montenegro',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'MA',
        name: 'Morocco',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'MZ',
        name: 'Mozambique',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'MM',
        name: 'Myanmar',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'NA',
        name: 'Namibia',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'NP',
        name: 'Nepal',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'NL',
        name: 'Netherlands',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      { id: 'NZ', name: 'New Zealand', value: 0, color: '#8aabb0' },
      {
        id: 'NI',
        name: 'Nicaragua',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'NE',
        name: 'Niger',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'NG',
        name: 'Nigeria',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'NO',
        name: 'Norway',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      { id: 'OM', name: 'Oman', value: 0, color: chart.colors.getIndex(0) },
      {
        id: 'PK',
        name: 'Pakistan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'PA',
        name: 'Panama',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      { id: 'PG', name: 'Papua New Guinea', value: 0, color: '#8aabb0' },
      {
        id: 'PY',
        name: 'Paraguay',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'PE',
        name: 'Peru',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'PH',
        name: 'Philippines',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'PL',
        name: 'Poland',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'PT',
        name: 'Portugal',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'PR',
        name: 'Puerto Rico',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'QA',
        name: 'Qatar',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'RO',
        name: 'Romania',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'RU',
        name: 'Russia',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'RW',
        name: 'Rwanda',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'SA',
        name: 'Saudi Arabia',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'SN',
        name: 'Senegal',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'RS',
        name: 'Serbia',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'SL',
        name: 'Sierra Leone',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'SG',
        name: 'Singapore',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'SK',
        name: 'Slovak Republic',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'SI',
        name: 'Slovenia',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      { id: 'SB', name: 'Solomon Islands', value: 0, color: '#8aabb0' },
      {
        id: 'SO',
        name: 'Somalia',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'ZA',
        name: 'South Africa',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'ES',
        name: 'Spain',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'LK',
        name: 'Sri Lanka',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'SD',
        name: 'Sudan',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'SR',
        name: 'Suriname',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'SZ',
        name: 'Swaziland',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'SE',
        name: 'Sweden',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'CH',
        name: 'Switzerland',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'SY',
        name: 'Syria',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'TW',
        name: 'Taiwan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'TJ',
        name: 'Tajikistan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'TZ',
        name: 'Tanzania',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'TH',
        name: 'Thailand',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      { id: 'TG', name: 'Togo', value: 0, color: chart.colors.getIndex(2) },
      {
        id: 'TT',
        name: 'Trinidad and Tobago',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'TN',
        name: 'Tunisia',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'TR',
        name: 'Turkey',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'TM',
        name: 'Turkmenistan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'UG',
        name: 'Uganda',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'UA',
        name: 'Ukraine',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'AE',
        name: 'United Arab Emirates',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'GB',
        name: 'United Kingdom',
        value: 0,
        color: chart.colors.getIndex(1)
      },
      {
        id: 'US',
        name: 'United States',
        value: 0,
        color: chart.colors.getIndex(4)
      },
      {
        id: 'UY',
        name: 'Uruguay',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'UZ',
        name: 'Uzbekistan',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'VE',
        name: 'Venezuela',
        value: 0,
        color: chart.colors.getIndex(3)
      },
      {
        id: 'PS',
        name: 'West Bank and Gaza',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'VN',
        name: 'Vietnam',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'YE',
        name: 'Yemen, Rep.',
        value: 0,
        color: chart.colors.getIndex(0)
      },
      {
        id: 'ZM',
        name: 'Zambia',
        value: 0,
        color: chart.colors.getIndex(2)
      },
      {
        id: 'ZW',
        name: 'Zimbabwe',
        value: 0,
        color: chart.colors.getIndex(2)
      }
    ];
*/

    // Set map definition
    chart.geodata = am4geodata_worldLow;

    // Set projection
    chart.projection = new am4maps.projections.Miller();

    // Create map polygon series
    let polygonSeries = chart.series.push(new am4maps.MapPolygonSeries());
    polygonSeries.exclude = ['AQ'];
    polygonSeries.useGeodata = true;
    polygonSeries.nonScalingStroke = true;
    polygonSeries.strokeWidth = 0.5;
    polygonSeries.calculateVisualCenter = true;

    let imageSeries = chart.series.push(new am4maps.MapImageSeries());
    console.log(mapData)
    imageSeries.data = mapData;
    console.log(imageSeries.data)
    imageSeries.dataFields.value = 'value';

    let imageTemplate = imageSeries.mapImages.template;
    imageTemplate.nonScaling = true;

    let circle = imageTemplate.createChild(am4core.Circle);
    circle.fillOpacity = 0.7;
    circle.propertyFields.fill = 'color';
    circle.tooltipText = '{name}: [bold]{value}[/]';

    // media query event handler

    imageSeries.heatRules.push({
      target: circle,
      property: 'radius',
      min: 4,
      max: 10,
      dataField: 'value'
    });

    chart.homeZoomLevel = 1;

    function changeMediaQuery(changed) {
      if (changed.matches) {
        chart.homeZoomLevel = 1.2;
      } else {
        chart.homeZoomLevel = 1;
      }
    }

    const mq = window.matchMedia('(max-width: 500px)');

    changeMediaQuery(mq);

    mq.addListener(changeMediaQuery);

    imageTemplate.adapter.add('latitude', function (latitude, target) {
      let polygon = polygonSeries.getPolygonById(target.dataItem.dataContext.id);
      if (polygon) {
        return polygon.visualLatitude;
      }
      return latitude;
    });

    imageTemplate.adapter.add('longitude', function (longitude, target) {
      let polygon = polygonSeries.getPolygonById(target.dataItem.dataContext.id);
      if (polygon) {
        return polygon.visualLongitude;
      }
      return longitude;
    });

    // Create a zoom control
    var zoomControl = new am4maps.ZoomControl();
    chart.zoomControl = zoomControl;
    zoomControl.slider.height = 100;

    var home = chart.chartContainer.createChild(am4core.Button);
    home.label.text = 'Home';
    home.align = 'right';
    home.events.on('hit', function (ev) {
      chart.goHome();
    });
  }); // end am4core.ready()
}
