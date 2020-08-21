import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:facial_capture/home.dart';
import 'package:facial_capture/main.dart';
import 'package:facial_capture/models/count.dart';
import 'package:facial_capture/models/filter.dart';
import 'package:facial_capture/models/profile.dart';
import 'package:facial_capture/screens/dialogs/profileDialog.dart';
import 'package:facial_capture/screens/dialogs/splitArray.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/profile.dart';
import 'models/profile.dart'; 

class ProfileList extends StatefulWidget {
  final List<Profile> profiles;
  final Filter filter; 
  final String username;  
  ProfileList({this.profiles, this.username, this.filter}); 
  // final String username; 
  // ProfileList({this.filter, this.username}); 
  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {

final ScrollController _scrollController  = ScrollController();
// final Count countController = Count();
var profiles;
double _threshold_temperature = 37.5;
double _temperature; 
bool _loading = true; 
Map<int, String> dates = {1: 'Mon', 2: 'Tues', 3: 'Wed', 4: 'Thur', 5: 'Fri', 6: 'Sat', 7: 'Sun'};
// Counter counter;

void _showEditPanel(Profile profile){
    showModalBottomSheet(
      backgroundColor:  Colors.transparent,
      context: context, 
      builder: (context) {
        return ProfileDialog(profile: profile, username: this.widget.username);
      }
    );
  }
  
  String formatDatetime(_currentDatetime) {
    var dateTimeFormat = DateTime.fromMillisecondsSinceEpoch(_currentDatetime).toString();
    var dateParse = DateTime.parse(dateTimeFormat);
    return ("${dates[dateParse.weekday]}, ${dateParse.day}-${dateParse.month}-${dateParse.year} ${dateParse.hour}:${dateParse.minute.toString().padLeft(2, '0')}");
  }

  Color formatTemperatureColour(previous_temp, current_temp) {
    if (previous_temp == 0.0) {
      return current_temp <= _threshold_temperature ?  Color(0xFF2DC990) : Color(0xFFFC6041);
    }
    return Color(0xFFFCB941);
  }

  // @override
  // void initState() {
  //   super.initState();
    // profiles = this.widget.profiles ?? [];
  // }

  //  @override
  // void didChangeDependencies() {
  //   List<AssetImage> allImages =
  //   BackgroundImage.getRandomImageForType(ImageType.LANDING)
  //       .getAllAvailableImages();
  //   allImages.forEach((AssetImage image) {
  //     precacheImage(image, context);
  //   });
  //   super.didChangeDependencies();
  // }

  // @override
  // void didChangeDependencies() {
  //   precacheImage(pro, context);
  //   super.didChangeDependencies();
  // }
  final img = base64Decode("\/9j\/4QBqRXhpZgAATU0AKgAAAAgABAEAAAQAAAABAAAASwEBAAQAAAABAAAAZIdpAAQAAAABAAAAPgESAAMAAAABAAAAAAAAAAAAAZIIAAQAAAABAAAAAAAAAAAAAQESAAMAAAABAAAAAAAAAAD\/4AAQSkZJRgABAQAAAQABAAD\/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH\/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH\/wAARCABkAEsDASIAAhEBAxEB\/8QAHgAAAgIDAQEBAQAAAAAAAAAABwgGCQAEBQMBAgr\/xAAvEAACAgICAQMEAgICAQUAAAABAgMEBREGEiEABxMUIjFBFTIII1FhQglDUnGB\/8QAGwEAAwEAAwEAAAAAAAAAAAAAAwQFAgABBgf\/xAAyEQABAwIEAwYFBAMAAAAAAAABAhEhAzEAEkFRBGFxEyIygZHBBUKhsfAUI9HhM1Ky\/9oADAMBAAIRAxEAPwCjBtBYRvYL9XJbwAIJ2UDx+RJrydAdfHkD17xwkSoo8LMG8EeNfE7aBP7BUfbo\/nYI3v17pGrdgQCVL\/sEAqQqkbXaD7wNq2m+4a879fYtxypJ\/YRElST42wI1rWvKuP8AnySe2j4+OFXlEegILSLx9jfH1wAxzy+ja20j6F3BxtPTVk7KQv3KgHUje10y9RohQeuyBrR8NrR9c2xUaWJ1ZVOtjZJLaIYgDQ2QewGzs7\/78eu7E6sVOv7mRyDodGArneurAb0Rsga22\/2B6QwFgyeSJGKk62RtguzrWiOq6\/WgdkDQ9ZTUII1ZuvPZ9fW+NsGIZh06F+f9YC3IaNmoVmgdowVLSdVDJsKsn3IVK7kKBWcBJVj2qSRkdvQ1jls3bLRTqoEZA2jN9zFIwW6EExEsZPt7ynWgZPJUsvmcOtqKaIRg9xKqgDRUsoVeu\/7aB6\/sKQvjW29BKngb9rOPiKlV7GRsWBBBWRV7PJrsCzOVjSJYx8sk8hSOKFTLLJHErutClVSpBcgMNWi2ssBPTrheohlJZ2J9eRG8acsa9evohPI1rQGjtQ2taGifwAoII8gkkaBZn279l7GWEeS5XDax1JZIfpsOR9PctohMksl+Q\/76NVgDGYEEeRlDTzLLRWKvLZk\/t17WUMAYcnm46+RzcUyTVtGWWljFiYrE8SdYhPa7uJ5LUqEV5EjWqIjG1uywVQMNAd3ILF1Dg\/J1G1A7gdvkDa0Ci\/7NM4Xq3qdxPFmU0zP+20\/L\/Ju3R2qdGxUH2T\/O55er2xIcZThqww1KcEVaCCKOOCCvFHDWhjiTQhhjQKsUSwiJVSIKiDSgkgIJMK5QdfvBBOwIWlAOySO\/xyb0dgr3JQ7Q6K6H4xNKDqDP0lBRgUaPcZidCyM6MB9jGIq7lkhKyMhVyJNzwQyaHWLqugVBWyp0fI8R2okGx5+yNR58b\/sZalgXckz66vhkBobbR9tByv6Q81ax7+cHWwsM+9DyS0tZR\/Zta6hxvQJ\/H9d72kj2idfywlKjt4OiFA\/48aAA8nz9p\/G\/scbCZ1by6rCxUn+xLzAg+Ng94ydEE\/snfn17iMrJGUA0I5yBoH\/3k672P23YedN+vIbXqsoEkQRD8nYnzLN6bNhQWFz+Ny9uj42BAWZF\/R7BWP2nZCaJP414\/Q\/ZA8gAetS1UMzwx2YJJ4CxkiWaMyx77dS6bZ4+xUhSy9SQ2iV362o1Uoq6JYspVlX8faCv5OgT+vBG+x8gH0pnJO8XMeTyIxWQZeCRZEJV0aPFYsBlZSGRkZewcEEFQVOtD0XheG\/VKqIC+zKaZUDlzOcyUt4gw715tbAeJ4gcOlCsmcKXlIzZSBlKn8J2Ibnexw30cPbs\/cAgkEaB89tHf5\/AAOifAPYnfkSLA0qdN7FivWrRWpldpbCwxpPMsURKLJMFWZ1jCt8aFyiglgAWZvSpca5byukUWG99ZVj7Ax5FPqU2xDaEvdLTsugQpsfEikdl0qL6JXGveGrdqwy5PE2KpswwuJKk8dtY\/q40LNKJFqOqQdjITGJ3kAbrGzajbFf4dxlMKyAVEjxGkWLQwyHKok7JBtjujxvDrAzE01F2CxEBLkKDhpEnLdmw1GNswMxicGNhFov48Ru7qraKN9w6Oe0yskaqVClRskjGwQSFCHQFysqmII8krvHtS7kOIxKI2iX5B8f9VV4mGlBHF+U4HJ2pHo5erM9mhX61ZJBDcWKObIxSTfR2DHZXT6Uv8YVuu0YowPos4iNYJhJG\/VZkkEpAVwT8TQqCpDCUlQpX\/X47jQHyMTFqlaCQoKSRcEFKp3CmLu+2r4pUyhQCkKCgYzAhQ01D9d2wYMTCvcGFPk6diXGwiECYM8krEkaeP4pVRZJ4JJOxTqxcEtK5ZEPeNftXx8PbWgB5KxOuzrZ0xAJIGtaAswOVkh0bMImjj+Nu8PQTvtoxpkkZY267Lltqo7yIEVT2cwVOQ4D6aHU9ZQE0FnmWvMApIAkhmnWVWAA+51BkGpNacelu2SdRpc9NC3QeWC5TEbWHoP65tuMVXnHsru2v7xqCfP5R5X\/BJ\/Jm2T\/bXjyOututjRK6qVLHbqR2AHliF0BrWyp8aG1+\/a+AZDHAJXmVUCrFKI\/6nW3r1pQNeDsqTokqB31o6Prr43Hq8s3XeglZgSu238swYhSQOq9xo6OyxPYBtD0qg8EbfaPpiQFERp+cxiLpjG6johOvIXYBPX5ADvYPgozD8nx+TvXpS+QYmxHyjOS3opK0dvLFa5mQwi2xpQaWsW+yUmOCRmEZYgRSABTG5jfL+PVC7a0FgRAGUr1Je03nwwY+CQCwBJ0d7LFG7TPDyDK2Fd1JytiVXQsjxlCqB0ZepVk6eWUht78ltH0\/8LSrtauVv8WoM95BgvBJ3BZt5CfHkGlTef3H6dxQPVn32fn0cPVXvHX69UJAjH6BOj1152XHnydljons\/ricOxjWcbiJWBWA4+gZCANyD6eAsiBiPu8n7vwNa0RseiLgKVuxaNnskgd0aazYhhtSSMqL0VZbEcrfJ16\/erAogXzoRhtTgpju8e42giSF4MZj5ZxEzLLahkpR6jf52sRRxIZVdDWiieOSGFZWeNpEmrFKu93RLCC7Fi9wnUQQ8ziaGdPeMBbAgDWmGEm\/k1nONbJY8xcsmrRRq0Q41gJo1QDTizlOTRqqKoOwy1lC6H3Aa2TsejJVzPKOK2uMRV81ZeLK1srkJIrEn8hAseMsYOJIVWwsjRKBkHjspVaKXbuiv3jhkHMx+Lxbc6nhsG\/WnfhvHJ6cbpWvL8cmb5eawMqjGsrv1yMhYxzCOL6aNO7ysIZweNzXuRcJitTVmmhw\/LUiwsEs73bItX+CPft1bFiKrQfFYhoUNxfmr5R\/r45KeNn+aU11atGlVypq0gtOWUqQFjwxICh4gC4Li5IZ8Fp1KlPvU1lJzGUqKXAXq7FwCYaS4GHD9qsbkuYcfFy\/BBFkVsISKizLFYqSMr1LfSUyfGJtzxhVmlDiFbKPGs8UUZZk9sbBcnrOQQpBUN1KlQV0ew2Na8gAH8gaPqY\/4scTyE2LzCzRVfgxwx1eNVsU7EzrNFLYpbjhtz2YFrRSTwJ8levXfqKtd5LOOvRV3Hj4MAupEZ27P5WJ1AXu3SMAxsdRJ1j3vz03ob0PF8bwVMcTVTSSAgKSUhLkB0pUQJs5s8CNgL\/D8arskdorvMxJuWUQC25Ac7ktYlqGY6Gu7oCRLMQ+wy7MapCQN6BIEagkggAa2D4HUr0nRh1GjIkYb9\/aGDgDXTe1UaH5HZh+B56FGAtVJKkMbWQJJIJAF+1GhKkAHaxAgH8KGA8L4kVSnG8so6qBHMsKqfAA+NZQOwZeoCud7JJY\/wDaj1cV9BF+mrPrqIe5dsL44clOT4mYA6+BHJ0rdTt+wB8hgr6J2Rr8eD+EMFP62\/ekPlP5G+JHA2C0duZOib39w1o7\/qF2QR1DWcV6ETpD2iDKA6SqVBDKzS9QVKgEbBjbRP586Oz61pfbTgmVVlyfDOMZEyCuGN3B420W7Aqe4lrOWKjRBb7RobP3AFjhOJHDLWpSCrMnLBAIkF2IP51gHEUTWQEhQSys0i8NcW9DhIuLCOCSKiwEcTHUDb0EZidoA2x\/tP40SWlJHV2lJEa9taD\/AMHxe91HWLDYeRVk7FZm+grF0kXa9omG1lAA77ZNnb6scwPtX7c0qlSCrwjjFSIfGBFUwuPqDtKds4SvWi32Ys7EAMxdnYj8mb4L2a9tpJGqjiOMirR0qa1atRZqcUCxzWY1jrRU5YViT4kjhRFQKEjjVSpQD04r4ogAtRqSQ8p0ZupJMnUvGFBwK3BK0hgoADNJJTrDeEvGvIDFfmQT+R9xZ56gZPl4Pwv4yOymOdeRe4SyjuAD2gZQWZAPwJE2CGDCy4\/G2eN8fv8AwxNyLGZRsXDdRFjvdcpA122tdoWEscd58Lj5m6gblxkSJ2+lVvTYQ\/4x+0WZuULVnjN+rrH2op5MVy7mWClnMdyvPTWe3h8\/RnnjhMl34YJZpokNuVQihtA48X\/xt9rTj8dE\/HLUuQrQ17NZpeR8llRcqcRdqpZmSfLyLM0ZvWY1Myy\/GJ32O2mUZ+I0jl\/brBrMEm4a+cO4O2O1cKsfMiS4lW4JgJNvzbEk\/wAPIKWQxGfoWmRcrYp4yS1WBYOywC\/WtyIUAVVH1ePAMe0SScLG7Ort6fM4WFOquIUYJH2Vinbt0Ukn\/Z\/5H7h\/0R4H49Cv2o9t\/bPgeSmu8auY7H5F4Y4MxBZz8luxFjZIZvjrNVt3pPpWkysVCyliWETv1atG6pK0ZaiPAYu7FDbeBJzYhhlEzfODIrxqUY9J1XynX8KN\/k7OyZtbLWqrqhKhnKYUA8BI3OgS0xEPjOYoAS7tzIElwLCZ29cfy\/QxRJXhYlVV4jIBoEN8r\/IrEa0C\/wAmzrYHcN+l9fuXKUKVmx8k6BGnXyWQgFYYE8E61pgT+QpI156gkW5TlTUqNetG6vLXopCzdgNvDWVS35\/O1P8AbRYk7H7IevcjuX2mmksPvbugVz16\/JKAAR12Nr4bwp0NliPDIQVdPu7EDXf662w+FgACS341xZ28o5NZJ7kYOlIzfJHIAdMB\/wDEV4dFjpVJ+QOWPna6P2kn1EOQe9t9j8fHq1Ybigje7NqWWGaVlhSWKEdoTJV38wEwmSWR0R4lRH+RU7Fy5kLseNq2EFi0SEaaSRYwRC7kM8KSOftjYApE47ggjX3CRYjA53G05\/maveDutiR1tQwOrJ9GDDBFPKHswkRzETt8RLCNGhUSO0ZE0EAAqLQAxLPYaNf8vjOckskWgmIgOAJJn+7RZB7E5CpnuO4yHMGDIW7L2pr0mSVbbNPLkbQX4o5hIlavFXSusVaFIq8Ji3DCvjTCYK3Q\/l7uMFatAKebuVojWjgRPpILDxiEiNAoEQQR\/r7lYNpwR6pJ5\/708y4dxaTHcXyNjjxjjhhku1kmp3rKSZKN7aC6rQ264Isz1RYx08MxjVZILaEq4Yf\/ABX988fxXFRxZCvPkMDkY1uz1qCwrkMTl1iWG01MTWIo7VS1KsSzQ2LcLCD4LlYpZWxWyXKnCEIFR4XCQLadA2wsw3xqnUFRa0CV00glOpcsWkTyZ5iHxa9l50xeUheCUxRWbEKoQraTcfRvA8IHZdknYJIPkEgmHjUoTkcaraZ1zODTkvxQo0cFeR5W4y9QH5XVws3FZLsJCRxxHKzQJBGIGms165T\/ACh4xlOTTcexdENJRkoLTvXJJJo7UU0EM3zmpD9NPUdbLWagSy5cLXW2Y\/p7UXol8t557lUuGWPcbhXI6lHM8RqyWeQUr1bDpj5PbqpDmMrmJUgy1eSvG\/H7065yxK1+pdmxFfORd7mTjw+NsAFFQKXhyGeLkH7GBd9scLlJFiAUknQulnueuxd8OT71e+3Hv8e\/avk\/unn8dmOQ08FUrVqmEwz1ocjkMlmblbFY6L552VKVCK9chly1\/wCG3Lj8THcux0MhLFHTsKrhf\/XB4dBiqMU3sJZmljgVXkf3JrxOzAn+6DghAcf1ZtkyMDISSx9CPD+8t\/3PxiY33lxuG5BhJkIOOyGIxMuBvKkgld7mFsoKVgosfWNp1ZIt7jQq05lWz3R\/wo9p+a895Fyvh3ubS9u+PZ2xVyFPhuF4HjMtiMLYlx9QZVMbat+5mGeGldyy3slWxkGJxuPwkVxcNi6VfGUKkSt0xSYpWCC7hTBQIgWOZjciPO+BHhhBqUhVgN3qiWcjVCkuCDYy48grWbzCzfKquTp3VmDfpiygjQA\/8XBIHgg\/g61DjJJ9N0HYljYC6BMjO1uUhFXXZm\/2D7OvnR87C9mhq8Z4XSmaX+OoySFPjZbLyZGLqzq5PxZCexXEg6L8ciIsgAZFfUkhMmq2+O4uD4K8+OpQRtsVqsaQVlaRmaRlSuojEjHuzhQoZm7FmJ36B2w0QpVrx9gfeCza42aaj8wEFyATtzDe2F09vfaLnvM+VQvVxgxNLHSXHvZHkRmxUEbjF5y5UhhgavJkrrWVxs9aJ6NCzXr3bOOrXJqr5OgJyrzPiOd9ueQvxjkiVlvxV4bSyUpJbOPuV5mnjSxj8g0MVTJVTLXmgF3HtYovPDPBHZeWvMsZExHvF7d8bzceJyXI46tjK1yar2KOX+jf6YWJJA+TOPGKgaIK6uli7FJ8k1SMLJJdgQz\/AJ5dwnvAuFyWJKS4XE8fg47Uy717MEtizDYuZC9dxrZHHVZkigu3Wx4mp\/V0bbY9m+pmgmlqxkK6oSmrUQE0FABKRTWC7kP2hXlU5CoCExEsSRoyZ1UkqdSXJOdJB7qT4AnMky0qVoWnC5UYMVIjJeweBztayGis0c7hqGWpzRuv3xSQ3IJl+9H6lWR1ZOwKEd\/UgrcM9qrKWWp4e37eZK21+VLfF5+mGXI2khFSZ8JZWxjq2Noyxlv4nBx8cgswT2a7zxuKdqlq5riue4tN9RDG+TwnZmFmBJHtU4UriZpMlEkYWJIyJw1yIPWaKATTLTNiGudyjYSwi9WXTbJ\/Y3oEnR1sn9D\/AIBIBBHrvMCHQs5TMKLWEFNgRzD7bkoJQoKYZhqwduSr\/UjliV4r2WlyfIeOtjc7x3I0JbUtTL8huSS4bJQYiPD5S7H82LaHKQ2zNyj+Oq1qkeXlSvUuZTJtPVd5KFixHhXEFxbUL13O25Wgr1dVcIwoUjMjPPKJbwaxdtRrOY5KtqucVOFiVpFYSNClbVea3Tk+WhZlqOCDqOQiNmDb++NiV8\/jYUMfOiNnZ\/8Abn3Cyis1ezkZqVmIJIgjeR4LYUnZ+N+8QMble8c3dSj7USAuEGsrIDkEDyN\/MC7QNMaK85JcgqbQDQDQCYdyxJJPIN6\/s77XW8RNhp+IcRzFAV8fUxuH5rxLB8xwGPjx8lZq5kr5OoudyEiRV06yXuSSypbWO6WZ4liYrxzWMdFBRxPE+ISUK0EEUDLmLnHkBEKGaOLDQcXz0VCCKwZYoI1y1wvCkcztE8jQRBziPKL+TqTST9ZTXeMCVQqySqwkfbxr1Qsg6gGMRBl13BbbNMVzcRUFp2U\/sNHIp\/8A1SARsefP\/wB+gmq8EqMks77TMTyfrbGCk6h7Bw7xazFhzi++KeEw1Sw8aymdhIoY\/wC38GTZbqCpAA148eCSfLeRJMXw7BWJGaeq0xVo1X5HDgBye2gykDYUDwNePWes9cUSASCQdxBvguoGjGNNMTWrhcRQjT6TG0oT8qqGWtEXG0LkiRlZyew35YgbJA2FKySKVukRbTjbp0bfXSl1B+0q2+sYUjt1KkggggDPWegkk3JPXHBr19hgdcv5jmcdi8nYpNWrtVgssojg0JDEjshlk7\/OSCo20csbkkt276YBDimcv35pJbDoWmt2HYBToF2V2692cjzIQNklVVQpAB3nrPTFDXz9sYqaeftgqQsQSPHgjzr87dD5A0PBOxoDyBvevUqwjtDfoMh0Szg\/rwAT+tfnQB3+gPWes9GX4T5fcYxTunp7Ycjg2TtUq9AQMoFh7IlDLsMIkg6+AR+jpt7B9GCWJGctojsEYgE6BZFJA3s6G\/GyTr8k+s9Z6Rwyq\/r\/ANHH\/9k=");
  
  @override
  Widget build(BuildContext context) {
    profiles = this.widget.profiles ?? [];
    // var profiles = Provider.of<List<Profile>>(context) ?? [];

    // int totalProfiles = profiles.length; 

    

    int currentMillieseconds = int.parse(DateTime.now().millisecondsSinceEpoch.toString());
    if (widget.filter.array != 'default' && widget.filter.temperature == 'default' && widget.filter.datetime == 'default') {
      print("array selected");
      profiles = profiles.where((i) => i.array == widget.filter.array.toString()).toList();
    } 
    else if (widget.filter.temperature != 'default' && widget.filter.array == 'default' && widget.filter.datetime == 'default' ) {
      print("temperature selected");
      profiles = profiles.where((i) =>  widget.filter.temperature == 'danger' ? (i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) >= 37.5 : (i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) < 37.5).toList();
    } 
    else if (widget.filter.datetime != 'default' && widget.filter.temperature == 'default' && widget.filter.array == 'default') {
      print("datetime selected"); 
      profiles = profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) >= int.parse(widget.filter.datetime) && (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) <= int.parse(widget.filter.datetime) + 86400000).toList();
    } 
    else if (widget.filter.array != 'default' && widget.filter.temperature != 'default' && widget.filter.datetime == 'default') {
      print("array and temperature selected");
      var temp_profiles = profiles.where((i) => i.array == widget.filter.array.toString()).toList();
      profiles = temp_profiles.where((i) =>  widget.filter.temperature == 'danger' ? (i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) >= 37.5 :(i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) < 37.5).toList();
    } 
    else if (widget.filter.array != 'default' && widget.filter.temperature == 'default' && widget.filter.datetime != 'default') {
      print("array and datetime selected"); 
      var temp_profiles = profiles.where((i) => i.array == widget.filter.array.toString()).toList();
      profiles = temp_profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? i.datetime >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : i.datetime >= int.parse(widget.filter.datetime) && i.datetime <= int.parse(widget.filter.datetime) + 86400000).toList();
    } 
    else if (widget.filter.array == 'default' && widget.filter.temperature != 'default' && widget.filter.datetime != 'default') {
      print("temperature and datetime selected");
      var temp_profiles = profiles.where((i) =>  widget.filter.temperature == 'danger' ?(i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) >= 37.5 : (i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) < 37.5).toList();
      profiles = temp_profiles.where((i) => int.parse(widget.filter.datetime) <= 60 ? (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) >= int.parse(widget.filter.datetime) && (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) <= int.parse(widget.filter.datetime) + 86400000).toList();
    } else if (widget.filter.array != 'default' && widget.filter.temperature != 'default' && widget.filter.datetime != 'default'){
      print("all selected");
      var temp_profiles = profiles.where((i) => i.array == widget.filter.array).toList();
      var temp_profiles_2 = temp_profiles.where((i) =>  widget.filter.temperature == 'danger' ? (i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) >= 37.5 : (i.manual_temperature == 0.0 ? i.temperature : i.manual_temperature) < 37.5).toList();
      profiles = temp_profiles_2.where((i) => int.parse(widget.filter.datetime) <= 60 ? (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) >= currentMillieseconds - (int.parse(widget.filter.datetime)*60000) : (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) >= int.parse(widget.filter.datetime) && (i.manual_datetime == 0 ? i.datetime : i.manual_datetime) <= int.parse(widget.filter.datetime) + 86400000).toList();
    }

    // secondary temperature check filter 
    if (widget.filter.processed) {
      profiles = profiles.where((i) => i.manual_temperature != 0.0).toList(); 
    }
    
        return Scrollbar(
          isAlwaysShown: true,
          controller: _scrollController,
                  child: GridView.builder(
                    controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: profiles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.75,
          ),
          itemBuilder: (BuildContext context, int index) {
            // print(base64Decode(profiles[index].image_captured));
            // String dir = (await getApplicationDocumentsDirectory()).path;
            // File file = File(
            //     "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
            // await file.writeAsBytes(bytes);
            // return file.path;
            // var date = new DateTime.fromMillisecondsSinceEpoch(profiles[index].datetime);
            // print(date);
            // print(profiles[index].image_captured.readAsBytesSync);
            // print(x)
            // print(x.lengthSync);
              return GestureDetector(
              //   onTap: () {
              //     print(profiles[index].uid);
              //     print(profiles[index].name);
              //     print(profiles[index].datetime);
              //     print(profiles[index].camera_number);
              //     print(profiles[index].camera_location);
              //     print(profiles[index].image_captured);
              //     print(profiles[index].temperature);
              //     print(profiles[index].array);
              //     print(profiles[index].location);
              //     print(profiles[index].manual_datetime);
              //     print(profiles[index].manual_temperature);
              //     print(profiles[index].manual_remarks);
              //     // print(profiles[index].manual_temperature);
              //     // print(profiles[index].temperature);
              //   },
                onTap: () => _showEditPanel( 
                  profiles[index]
                  
                ),
                child: Card(
                  elevation: 8,
                  color: formatTemperatureColour(profiles[index].manual_temperature, profiles[index].temperature),
                  shape: RoundedRectangleBorder(
                    side:  BorderSide(
                      color: formatTemperatureColour(profiles[index].manual_temperature, profiles[index].temperature),
                      width: 3.0),
                    borderRadius: BorderRadius.circular(10.0)
                  ),
                  margin: EdgeInsets.all(10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                          child: Container(
                          // width: double.infinity,
                          // height: 120,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage("http://192.168.1.104:82/imgSnap/${profiles[index].uid}" + "${profiles[index].camera_number}" + "${profiles[index].datetime}.jpg"),
                              // image: NetworkImage(profiles[index].image_captured),         
                              // image: MemoryImage((profiles[index].image_captured)),
                              // image: MemoryImage(img),
                              fit: BoxFit.cover
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Expanded(
                        flex: 1,
                        child: Column(
                            children:[
                            Text(
                            // profiles[index].datetime .toString(),
                            formatDatetime(profiles[index].manual_datetime == 0 ? profiles[index].datetime: profiles[index].manual_datetime),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black
                              // profiles[index].temperature <= _threshold_temperature ? Colors.black : Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.5),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                // profiles[index].manual_temperature.toString() + "°C", 
                                profiles[index].manual_temperature == 0.0 ? "-" : (profiles[index].temperature.toString() +  "°C"),
                                                                // profiles[index].manual_temperature == 0.0 ? "-" : profiles[index].temperature.toString() + "°C",
                                style: TextStyle(
                                  // fontWeight: FontWeight.w400,
                                  fontSize: 11,
                                  color: formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // profiles[index].temperature <=_threshold_temperature ? Colors.black : Colors.white,
                                )
                              ),
                              Text(
                                '|',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // profiles[index].temperature <=_threshold_temperature ? Colors.black : Colors.white,
                                )
                              ),
                              Text(
                                profiles[index].manual_temperature == 0.0 ? (profiles[index].temperature.toString() + "°C") : (profiles[index].manual_temperature.toString() +  "°C"),
                                // profiles[index].manual_temperature.toString() + "°C", 
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // formatColour(profiles[index].temperature, profiles[index].manual_temperature)
                                  // profiles[index].temperature <= _threshold_temperature ? Colors.black : Colors.white,
                                )
                              )
                            ],
                          ),                        
                          ]
                        ),
                      ),
                    ]
                  ),
                // ), 
                ),
              );
          },
      ),
        );
    // );
  }


  Color formatColour(double temperature, double manual_temperature) {
    if (manual_temperature == 0.0) {
      if (temperature >= 37.5) {
        return Color(0xFFFE0202); 
      }
      return Colors.black;
    } else {
      if (manual_temperature >= 37.5) {
        return Color(0xFFFE0202); 
      }
      return Colors.black;
    }
  }
}

