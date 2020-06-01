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
            aria-valuemin="0"
            aria-valuemax="100"
            @if (count($project->issues()->get()) > 0)
            style="width: {{count($project->issues()->where('is_completed', '=', 'true')->get()) / count($project->issues()->get()) * 100}}%;"
            @else
            style="width: 0%;"
            @endif
            
        ></div>
        </div>
        <div>
        Tasks Completed:
        <span class="text-inverse">{{count($project->issues()->where('is_completed', '=', 'true')->get())}} / {{count($project->issues()->get())}}</span
        >
        </div>
    </td>
    <td class = "text-center delete-project">
        <button class="btn btn-outline-danger table-link" data-project = "{{$project['id']}}">
        <i class="fa fa-trash"></i> 
            Delete
        </button>
    </td>
</tr>