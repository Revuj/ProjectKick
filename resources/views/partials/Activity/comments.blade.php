<div class="timeline-item">
    <p class="time">{{date('d M Y, h:i a', strtotime($elem['date']))}}</p>
    <div class="content">
        <div class="d-flex justify-content-between align-items-center">
                <div class="title text-left author">
                The user 
                <a class = "nostyle" href="/users/{{$elem['user_id']}}">
                    <span class = "author-reference">{{$elem['username']}}</span>
                </a>
                 made a comment on the issue 
                 <a class = "nostyle" href="/issues/{{$elem['issue_id']}}">

                 <span class = "author-reference">{{$elem['name']}}</span>
                 </a>

                </div>
            <div class="time-mobile">
                {{date('d M Y, h:i a', strtotime($elem['date']))}}
            </div>
        </div>

        <p class="text-left my-1">
            @php
                $first10words = implode(' ', array_slice(str_word_count($elem['content'],1), 0, 10));
            @endphp

            @if (str_word_count($elem['content']) > 10)
                {{$first10words}} <span>...</span>
            @else
                {{$first10words}}
            @endif
        </p>
        <div class="author w-100 d-flex flex-row-reverse my-2">
            <div class = "w-20 text-left p-1">
                <span class="status open bg-info p-1">Made</span> by
                <a class = "nostyle" href="/users/{{$elem['user_id']}}">
                    <span class="author-reference text-left">{{$elem['username']}}</span>
                </a>
            </div>
        </div>
    </div>
</div>