from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Card
from .serializers import CardSerializer


class CardListCreateView(APIView):
    serializer_class = CardSerializer
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        cards = Card.objects.filter(user=request.user)
        serializer = CardSerializer(cards, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = CardSerializer(data=request.data, context={'request': request})

        if serializer.is_valid():
            card = serializer.save()
            return Response(CardSerializer(card).data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CardDetailView(APIView):
    serializer_class = CardSerializer
    permission_classes = [IsAuthenticated]
    
    def get_card(self, request, card_id):
        # a user can only touch their own cards
        try:
            return Card.objects.get(id=card_id, user=request.user)
        except Card.DoesNotExist:
            return None

    def get(self, request, card_id):
        card = self.get_card(request, card_id)

        if card is None:
            return Response({'detail': 'Card not found.'}, status=status.HTTP_404_NOT_FOUND)

        return Response(CardSerializer(card).data)

    def delete(self, request, card_id):
        card = self.get_card(request, card_id)

        if card is None:
            return Response({'detail': 'Card not found.'}, status=status.HTTP_404_NOT_FOUND)

        card.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
