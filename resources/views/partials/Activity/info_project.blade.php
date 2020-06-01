<div class="timeline-item">
    <p class="time">{{date('d M Y, h:i a', strtotime($project['creation_date']))}}</p>
    <div class="content">
        <div class="d-flex justify-content-between align-items-center">
                <div class="title text-left author">
                <h2 class = "h1 text-center mb-3"> A new start <i class="fas fa-birthday-cake"></i> </h2>
                The project 

                 <span style = "cursor:auto;" class = "author-reference">{{$project['name']}}</span>

                 was created


                </div>
            <div class="time-mobile">
                {{date('d M Y, h:i a', strtotime($project['creation']))}}
            </div>
        </div>

        <p class="text-left my-1">
        @if ($project['description'] === NULL)
            The project does not have a description
            @else
                @php
                    $first10words = implode(' ', array_slice(str_word_count($project['description'],1), 0, 10));
                @endphp

                @if (str_word_count($project['description']) > 10)
                    {{$first10words}} <span>...</span>
                @else
                    {{$first10words}}
                @endif
            @endif
        </p>
        <div class="author w-100 d-flex flex-row-reverse my-2 d-none">
            <div class = "w-20 text-left p-1">
                <span class="status open bg-primary p-1"> Created by </span> 
                    <a href="/users/{{$author['id']}}">
                        <span class="author-reference text-left mx-1"> {{$author['name']}}</span>
                    </a>
            </div>
        </div>
    </div>
</div>