
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

void main() {
  print("load game widget");
  
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasTappables{
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();
  DialogButton dialogButton = DialogButton();//BUTTON
  final Vector2 buttonSize = Vector2(75.0, 75.0);
  final double charsize = 300;//CHARACTER SIZE
  bool turnaway = false;// MUDNE KE LIYE
  int dialogLevel =0;//to see which piece of dialog should appear

  TextPaint dialogTextPaint = TextPaint(style: const TextStyle(fontSize:36));
  @override
  Future<void> onLoad() async{
    super.onLoad();
    final screenWidth = size[0];
    final screenHeight = size[1];
    final textBoxHeight = 100;
    print("load game assets");
    //bg2
    add(background2
      ..sprite  = await loadSprite('bg2.jpg')
      ..size = Vector2(size[0], size[1]-100));


    //background
    add(background
      ..sprite  = await loadSprite('bg.jpg')
      ..size = Vector2(size[0], size[1]-100));
    girl
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2(charsize,charsize)
      ..x = screenWidth - charsize
      ..y = screenHeight-charsize-textBoxHeight
      ..anchor = Anchor.topCenter;

    add(girl);
    boy
      ..sprite = await loadSprite(('man.png'))
      ..size = Vector2(charsize, charsize  )
      ..x = charsize
      ..y = screenHeight-charsize-textBoxHeight
      ..anchor = Anchor.topCenter;
    add(boy);

    dialogButton
      ..sprite = await loadSprite('next_button.png')
      ..size = buttonSize
      ..position = Vector2(size[0]-buttonSize[0] - 10,size[1]-buttonSize[1] - 10 );
    

  }
  @override
  void update(double dt){
    super.update(dt);
    if(girl.x > size[0]/2 + charsize/2){
      girl.x -=30*dt;
      if(boy.x >50 && dialogLevel == 0){
        dialogLevel = 1;
      }
      if(girl.x<size[0] - charsize - 100 && dialogLevel == 1){
        dialogLevel = 2;
      }
    }
    else if(turnaway == false){
      boy.flipHorizontally();
      turnaway = true;
      if(dialogLevel == 2){
        dialogLevel = 3;
      }
    }
    if(boy.x < size[0]/2 -charsize/2) {
      boy.x += 1;
    }
    if(turnaway==true){
      boy.x = boy.x - 2;
      //mudd ke bhago
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    switch (dialogLevel) {
      case 1:
        dialogTextPaint.render(canvas, "Tracy: huh?",
          Vector2(10, size[1] - 100.0));
        break;
      case 2:
        dialogTextPaint.render(canvas, "Tracy : plz do not leave me"
            " Just stop!!", Vector2(10, size[1] - 100.0));
        break;
      case 3:
        dialogTextPaint.render(canvas, "John:not interested",Vector2(10, size[1] - 100.0) );
        DialogButton().scene2Level = 1;
        break;
    }
    switch(dialogButton.scene2Level){
      case 1:
        // button visible nhi hai
        canvas.drawRect(Rect.fromLTWH(0, size[1]-100, size[0]-60,100 ),Paint()..color = Colors.black);
        dialogTextPaint.render(canvas, "Tracy :Please!!",
            Vector2(10, size[1] - 100.0));
        turnaway = false;
        boy.flipHorizontally();
        break;
    }
  }
}

class DialogButton extends SpriteComponent with Tappable{
  int scene2Level = 0;
  @override
  bool onTapDown(TapDownInfo event){
    try{
      print("move to next screen");
      return true;
    } catch(error){
      print('error');
      return false;
    }
  }
}