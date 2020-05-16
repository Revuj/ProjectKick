<tr>
    <td data-label="Project">
        <a href="#" class="project-link">
        {{$project['name']}}
        </a>
    </td>
    <td data-label="Created">
    {{ date('d M Y, h:i a', strtotime($project['creation_date'])) }}    
    </td>
    <td data-label="Status" class="align-center">
        <span class="badge {{(($project['finish_date'] === null || $project['finish_date'] >= $today) ? 'text-success' : 'text-danger' )}}">
        @if ($project['finish_date'] === null || $project['finish_date'] >= $today)
                Active
        @else
            Inactive
        @endif
        </span>
    </td>
    <td data-label="Progress">
        <div class="mb-2 progress" style="height: 5px;">
        <div
            class="progress-bar"
            role="progressbar"
            aria-valuenow="80"
            aria-valuemin="0"
            aria-valuemax="100"
            style="width: 80%;"
        ></div>
        </div>
        <div>
        Tasks Completed:
        <span class="text-inverse">36/94</span
        >
        </div>
    </td>
    <td>
        <a href="#" class="table-link">
        <button class="btn btn-outline-danger">
        <i class="fa fa-trash"></i> 
            Delete
        </button>
        </a>
    </td>
</tr>