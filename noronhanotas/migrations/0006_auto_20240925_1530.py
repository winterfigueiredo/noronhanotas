# Generated by Django 3.1.14 on 2024-09-25 18:30

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('noronhanotas', '0005_auto_20240925_0105'),
    ]

    operations = [
        migrations.AddField(
            model_name='notas',
            name='comprovante',
            field=models.ImageField(default=1, upload_to=''),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='notas',
            name='status',
            field=models.CharField(default='pendente', max_length=20),
        ),
        migrations.AddField(
            model_name='notas',
            name='vencimento',
            field=models.DateTimeField(auto_now=True),
        ),
    ]
