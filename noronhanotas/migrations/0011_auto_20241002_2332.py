# Generated by Django 3.1.14 on 2024-10-03 02:32

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('noronhanotas', '0010_auto_20241002_2318'),
    ]

    operations = [
        migrations.AlterField(
            model_name='notas',
            name='atrasada',
            field=models.CharField(default='não', max_length=20),
        ),
    ]
