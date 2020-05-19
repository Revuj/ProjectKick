document.addEventListener('DOMContentLoaded', build);

const update_projectNr = document.getElementById('project-update')
const update_taskNr = document.getElementById('task-update');
const update_userNr = document.getElementById('user-update');
const update_reportNr = document.getElementById('report-update');

let nr_projetcs= document.getElementById('number-projects');
let nr_tasks = document.getElementById('number-tasks');
let nr_users = document.getElementById('number-users');
let nr_reports = document.getElementById('number-reports');




update_projectNr.addEventListener('click', ()=> {
  animation360deg (update_projectNr.querySelector('.reload'), 1000);
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

update_taskNr.addEventListener('click', ()=> {
  animation360deg (update_taskNr.querySelector('.reload'), 1000);

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

update_userNr.addEventListener('click', ()=> {
  animation360deg (update_userNr.querySelector('.reload'), 1000);
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

update_reportNr.addEventListener('click', ()=> {
  animation360deg (update_reportNr.querySelector('.reload'), 1000);

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



function animation360deg (element, duration) {
  element.animate( [
    { transform: 'rotateZ(0deg)' }, 
    { transform: 'rotateZ(360deg)' }
  ], {duration: duration});
}

function build() {
  //getCountries();
  //getIntelPerMonth();
  //getBannedUsers();
  getRecentUsers();

}

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
         
          console.log(data);

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
        data: [86, 114, 106, 106, 107, 111, 133, 221, 783, 2478, 912, 912],
        label: 'Number of project',
        borderColor: '#3e95cd',
        backgroundColor: 'rgba(1,181,198,0.2)',
        fill: true
      },
      {
        data: [282, 350, 411, 502, 635, 809, 947, 1402, 3700, 267, 898, 611],
        label: 'Tasks done',
        borderColor: '#8e5ea2',
        backgroundColor: 'rgba(179,181,198,0.2)',

        fill: true
      },
      {
        data: [168, 170, 178, 190, 203, 276, 408, 547, 675, 734, 1200, 1700],
        label: 'Number of reports',
        borderColor: '#3cba9f',
        backgroundColor: 'rgba(1,81,198,0.2)',

        fill: true
      }
    ]
  },
  options: {
    title: {
      display: true,
      text: 'Numbers last 12 months'
    },

    legend: {
      display: false
    }
  }
});

new Chart(document.getElementById('doughnut-chart'), {
  type: 'doughnut',
  data: {
    labels: ['Small Teams (< 5)', 'Medium Teams', 'Big teams (> 20)'],
    datasets: [
      {
        backgroundColor: ['#3e95cd', '#8e5ea2', '#3cba9f'],
        data: [2478, 5267, 734]
      }
    ]
  },
  options: {
    plugins: {
      doughnutlabel: {
        labels: [
          {
            text: 'Teams Size',
            font: {
              size: '60'
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

am4core.ready(function() {
  // Themes begin
  am4core.useTheme(am4themes_animated);
  // Themes end

  // Create map instance
  let chart = am4core.create('chartdiv', am4maps.MapChart);

  let label = chart.chartContainer.createChild(am4core.Label);
  label.text = 'User Distribution';
  label.align = 'left';

  let mapData = [
    {
      id: 'AF',
      name: 'Afghanistan',
      value: 32358260,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'AL',
      name: 'Albania',
      value: 3215988,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'DZ',
      name: 'Algeria',
      value: 35980193,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'AO',
      name: 'Angola',
      value: 19618432,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'AR',
      name: 'Argentina',
      value: 40764561,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'AM',
      name: 'Armenia',
      value: 3100236,
      color: chart.colors.getIndex(1)
    },
    { id: 'AU', name: 'Australia', value: 22605732, color: '#8aabb0' },
    {
      id: 'AT',
      name: 'Austria',
      value: 8413429,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'AZ',
      name: 'Azerbaijan',
      value: 9306023,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'BH',
      name: 'Bahrain',
      value: 1323535,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'BD',
      name: 'Bangladesh',
      value: 150493658,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'BY',
      name: 'Belarus',
      value: 9559441,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'BE',
      name: 'Belgium',
      value: 10754056,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'BJ',
      name: 'Benin',
      value: 9099922,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'BT',
      name: 'Bhutan',
      value: 738267,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'BO',
      name: 'Bolivia',
      value: 10088108,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'BA',
      name: 'Bosnia and Herzegovina',
      value: 3752228,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'BW',
      name: 'Botswana',
      value: 2030738,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'BR',
      name: 'Brazil',
      value: 196655014,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'BN',
      name: 'Brunei',
      value: 405938,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'BG',
      name: 'Bulgaria',
      value: 7446135,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'BF',
      name: 'Burkina Faso',
      value: 16967845,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'BI',
      name: 'Burundi',
      value: 8575172,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'KH',
      name: 'Cambodia',
      value: 14305183,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'CM',
      name: 'Cameroon',
      value: 20030362,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'CA',
      name: 'Canada',
      value: 34349561,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'CV',
      name: 'Cape Verde',
      value: 500585,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'CF',
      name: 'Central African Rep.',
      value: 4486837,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'TD',
      name: 'Chad',
      value: 11525496,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'CL',
      name: 'Chile',
      value: 17269525,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'CN',
      name: 'China',
      value: 1347565324,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'CO',
      name: 'Colombia',
      value: 46927125,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'KM',
      name: 'Comoros',
      value: 753943,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'CD',
      name: 'Congo, Dem. Rep.',
      value: 67757577,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'CG',
      name: 'Congo, Rep.',
      value: 4139748,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'CR',
      name: 'Costa Rica',
      value: 4726575,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'CI',
      name: "Cote d'Ivoire",
      value: 20152894,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'HR',
      name: 'Croatia',
      value: 4395560,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'CU',
      name: 'Cuba',
      value: 11253665,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'CY',
      name: 'Cyprus',
      value: 1116564,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'CZ',
      name: 'Czech Rep.',
      value: 10534293,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'DK',
      name: 'Denmark',
      value: 5572594,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'DJ',
      name: 'Djibouti',
      value: 905564,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'DO',
      name: 'Dominican Rep.',
      value: 10056181,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'EC',
      name: 'Ecuador',
      value: 14666055,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'EG',
      name: 'Egypt',
      value: 82536770,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'SV',
      name: 'El Salvador',
      value: 6227491,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'GQ',
      name: 'Equatorial Guinea',
      value: 720213,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'ER',
      name: 'Eritrea',
      value: 5415280,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'EE',
      name: 'Estonia',
      value: 1340537,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'ET',
      name: 'Ethiopia',
      value: 84734262,
      color: chart.colors.getIndex(2)
    },
    { id: 'FJ', name: 'Fiji', value: 868406, color: '#8aabb0' },
    {
      id: 'FI',
      name: 'Finland',
      value: 5384770,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'FR',
      name: 'France',
      value: 63125894,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'GA',
      name: 'Gabon',
      value: 1534262,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'GM',
      name: 'Gambia',
      value: 1776103,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'GE',
      name: 'Georgia',
      value: 4329026,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'DE',
      name: 'Germany',
      value: 82162512,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'GH',
      name: 'Ghana',
      value: 24965816,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'GR',
      name: 'Greece',
      value: 11390031,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'GT',
      name: 'Guatemala',
      value: 14757316,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'GN',
      name: 'Guinea',
      value: 10221808,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'GW',
      name: 'Guinea-Bissau',
      value: 1547061,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'GY',
      name: 'Guyana',
      value: 756040,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'HT',
      name: 'Haiti',
      value: 10123787,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'HN',
      name: 'Honduras',
      value: 7754687,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'HK',
      name: 'Hong Kong, China',
      value: 7122187,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'HU',
      name: 'Hungary',
      value: 9966116,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'IS',
      name: 'Iceland',
      value: 324366,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'IN',
      name: 'India',
      value: 1241491960,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'ID',
      name: 'Indonesia',
      value: 242325638,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'IR',
      name: 'Iran',
      value: 74798599,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'IQ',
      name: 'Iraq',
      value: 32664942,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'IE',
      name: 'Ireland',
      value: 4525802,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'IL',
      name: 'Israel',
      value: 7562194,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'IT',
      name: 'Italy',
      value: 60788694,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'JM',
      name: 'Jamaica',
      value: 2751273,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'JP',
      name: 'Japan',
      value: 126497241,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'JO',
      name: 'Jordan',
      value: 6330169,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'KZ',
      name: 'Kazakhstan',
      value: 16206750,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'KE',
      name: 'Kenya',
      value: 41609728,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'KP',
      name: 'Korea, Dem. Rep.',
      value: 24451285,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'KR',
      name: 'Korea, Rep.',
      value: 48391343,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'KW',
      name: 'Kuwait',
      value: 2818042,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'KG',
      name: 'Kyrgyzstan',
      value: 5392580,
      color: chart.colors.getIndex(0)
    },
    { id: 'LA', name: 'Laos', value: 6288037, color: chart.colors.getIndex(0) },
    {
      id: 'LV',
      name: 'Latvia',
      value: 2243142,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'LB',
      name: 'Lebanon',
      value: 4259405,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'LS',
      name: 'Lesotho',
      value: 2193843,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'LR',
      name: 'Liberia',
      value: 4128572,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'LY',
      name: 'Libya',
      value: 6422772,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'LT',
      name: 'Lithuania',
      value: 3307481,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'LU',
      name: 'Luxembourg',
      value: 515941,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'MK',
      name: 'Macedonia, FYR',
      value: 2063893,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'MG',
      name: 'Madagascar',
      value: 21315135,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'MW',
      name: 'Malawi',
      value: 15380888,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'MY',
      name: 'Malaysia',
      value: 28859154,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'ML',
      name: 'Mali',
      value: 15839538,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'MR',
      name: 'Mauritania',
      value: 3541540,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'MU',
      name: 'Mauritius',
      value: 1306593,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'MX',
      name: 'Mexico',
      value: 114793341,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'MD',
      name: 'Moldova',
      value: 3544864,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'MN',
      name: 'Mongolia',
      value: 2800114,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'ME',
      name: 'Montenegro',
      value: 632261,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'MA',
      name: 'Morocco',
      value: 32272974,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'MZ',
      name: 'Mozambique',
      value: 23929708,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'MM',
      name: 'Myanmar',
      value: 48336763,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'NA',
      name: 'Namibia',
      value: 2324004,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'NP',
      name: 'Nepal',
      value: 30485798,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'NL',
      name: 'Netherlands',
      value: 16664746,
      color: chart.colors.getIndex(1)
    },
    { id: 'NZ', name: 'New Zealand', value: 4414509, color: '#8aabb0' },
    {
      id: 'NI',
      name: 'Nicaragua',
      value: 5869859,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'NE',
      name: 'Niger',
      value: 16068994,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'NG',
      name: 'Nigeria',
      value: 162470737,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'NO',
      name: 'Norway',
      value: 4924848,
      color: chart.colors.getIndex(1)
    },
    { id: 'OM', name: 'Oman', value: 2846145, color: chart.colors.getIndex(0) },
    {
      id: 'PK',
      name: 'Pakistan',
      value: 176745364,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'PA',
      name: 'Panama',
      value: 3571185,
      color: chart.colors.getIndex(4)
    },
    { id: 'PG', name: 'Papua New Guinea', value: 7013829, color: '#8aabb0' },
    {
      id: 'PY',
      name: 'Paraguay',
      value: 6568290,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'PE',
      name: 'Peru',
      value: 29399817,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'PH',
      name: 'Philippines',
      value: 94852030,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'PL',
      name: 'Poland',
      value: 38298949,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'PT',
      name: 'Portugal',
      value: 10689663,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'PR',
      name: 'Puerto Rico',
      value: 3745526,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'QA',
      name: 'Qatar',
      value: 1870041,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'RO',
      name: 'Romania',
      value: 21436495,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'RU',
      name: 'Russia',
      value: 142835555,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'RW',
      name: 'Rwanda',
      value: 10942950,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'SA',
      name: 'Saudi Arabia',
      value: 28082541,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'SN',
      name: 'Senegal',
      value: 12767556,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'RS',
      name: 'Serbia',
      value: 9853969,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'SL',
      name: 'Sierra Leone',
      value: 5997486,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'SG',
      name: 'Singapore',
      value: 5187933,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'SK',
      name: 'Slovak Republic',
      value: 5471502,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'SI',
      name: 'Slovenia',
      value: 2035012,
      color: chart.colors.getIndex(1)
    },
    { id: 'SB', name: 'Solomon Islands', value: 552267, color: '#8aabb0' },
    {
      id: 'SO',
      name: 'Somalia',
      value: 9556873,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'ZA',
      name: 'South Africa',
      value: 50459978,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'ES',
      name: 'Spain',
      value: 46454895,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'LK',
      name: 'Sri Lanka',
      value: 21045394,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'SD',
      name: 'Sudan',
      value: 34735288,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'SR',
      name: 'Suriname',
      value: 529419,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'SZ',
      name: 'Swaziland',
      value: 1203330,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'SE',
      name: 'Sweden',
      value: 9440747,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'CH',
      name: 'Switzerland',
      value: 7701690,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'SY',
      name: 'Syria',
      value: 20766037,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'TW',
      name: 'Taiwan',
      value: 23072000,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'TJ',
      name: 'Tajikistan',
      value: 6976958,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'TZ',
      name: 'Tanzania',
      value: 46218486,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'TH',
      name: 'Thailand',
      value: 69518555,
      color: chart.colors.getIndex(0)
    },
    { id: 'TG', name: 'Togo', value: 6154813, color: chart.colors.getIndex(2) },
    {
      id: 'TT',
      name: 'Trinidad and Tobago',
      value: 1346350,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'TN',
      name: 'Tunisia',
      value: 10594057,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'TR',
      name: 'Turkey',
      value: 73639596,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'TM',
      name: 'Turkmenistan',
      value: 5105301,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'UG',
      name: 'Uganda',
      value: 34509205,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'UA',
      name: 'Ukraine',
      value: 45190180,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'AE',
      name: 'United Arab Emirates',
      value: 7890924,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'GB',
      name: 'United Kingdom',
      value: 62417431,
      color: chart.colors.getIndex(1)
    },
    {
      id: 'US',
      name: 'United States',
      value: 313085380,
      color: chart.colors.getIndex(4)
    },
    {
      id: 'UY',
      name: 'Uruguay',
      value: 3380008,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'UZ',
      name: 'Uzbekistan',
      value: 27760267,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'VE',
      name: 'Venezuela',
      value: 29436891,
      color: chart.colors.getIndex(3)
    },
    {
      id: 'PS',
      name: 'West Bank and Gaza',
      value: 4152369,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'VN',
      name: 'Vietnam',
      value: 88791996,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'YE',
      name: 'Yemen, Rep.',
      value: 24799880,
      color: chart.colors.getIndex(0)
    },
    {
      id: 'ZM',
      name: 'Zambia',
      value: 13474959,
      color: chart.colors.getIndex(2)
    },
    {
      id: 'ZW',
      name: 'Zimbabwe',
      value: 12754378,
      color: chart.colors.getIndex(2)
    }
  ];

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
  imageSeries.data = mapData;
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

  imageTemplate.adapter.add('latitude', function(latitude, target) {
    let polygon = polygonSeries.getPolygonById(target.dataItem.dataContext.id);
    if (polygon) {
      return polygon.visualLatitude;
    }
    return latitude;
  });

  imageTemplate.adapter.add('longitude', function(longitude, target) {
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
  home.events.on('hit', function(ev) {
    chart.goHome();
  });
}); // end am4core.ready()
