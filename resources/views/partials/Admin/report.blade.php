<div class="w-100">
    <p class="time">some</p>
    <div class="content">
        <div class="d-flex justify-content-between align-items-center">
                <div class="title text-left author h5">
                    The user 
                    <a class = "nostyle" href="/users/{{$report['reports_id']}}">
                        <span class = "author-reference">{{$report['sender']}}</span>
                    </a> reported the user
                    <a class = "nostyle" href="/users/{{$report['reported_id']}}">
                        <span class = "author-reference">{{$report['receiver']}}</span>
                    </a>  
                </div>

        </div>
        <div id = "{{$report['id']}}">
            <p class="my-2 pl-2 small-text">
                @php
                    $first10words = implode(' ', array_slice(str_word_count($report['description'],1), 0, 40));
                @endphp

                @if (str_word_count($report['description']) > 10)
                    {{$first10words}}  ...
                @else
                    {{$first10words}}
                @endif
            </p>

            <p  class = "d-none my-2 full-text">
                {{$report['description']}}
            </p>
        </div>

        <button data-target = "{{$report['id']}}" class = "read-more text-white my-2 secondary-button clickable rounded border-0">
            Read more
        </button>
    </div>
</div>