<div class="timeline-item">
    <p class="time">{{date('d M Y, h:i a', strtotime($elem['date']))}}</p>
    <div class="content">
        <div class="d-flex justify-content-between align-items-center">
                <div class="title text-left author">
             
                A new channel

                 <span style = "cursor:auto;" class = "author-reference">{{$elem['name']}}</span>

                 was created for the project

                </div>
            <div class="time-mobile">
                {{date('d M Y, h:i a', strtotime($elem['date']))}}
            </div>
        </div>

        <p class="text-left my-1">
        @if ($elem['description'] === NULL)
            The channel does not have a description
            @else
                @php
                    $first10words = implode(' ', array_slice(str_word_count($elem['description'],1), 0, 10));
                @endphp

                @if (str_word_count($elem['description']) > 10)
                    {{$first10words}} <span>...</span>
                @else
                    {{$first10words}}
                @endif
            @endif
        </p>
        <div class="author w-100 d-flex flex-row-reverse my-2 d-none">
            <div class = "w-20 text-left p-1">
                <span class="status open bg-primary p-1">New channel</span> 
                    <span class="author-reference text-left">created</span>
            </div>
        </div>
    </div>
</div>