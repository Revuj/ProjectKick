<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>@yield('title')</title>
    @yield('script')
    
    @yield('style')

    <script type="text/javascript">

        // Fix for Firefox autofocus CSS bug
        // See: http://stackoverflow.com/questions/18943276/html-5-autofocus-messes-up-css-loading/18945951#18945951

    </script>

  </head>
  <body>
    <div class="page-wrapper h-100 is-collapsed">
      @if(empty($hide_navbar))
            @include('inc.navbar')
      @endif
      <noscript>
          <span class="warning">Warning:&nbsp;</span><i>JavaScript</i> is currently disabled and is required to fully experience this website
      </noscript>

      <div class="main-container">
        @yield('content')
      </div> 
    </div>

  </body>
</html>
